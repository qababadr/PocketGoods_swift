//
//  AuthenticationRepositoryImpl.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//

import Combine
import CoreApp
import Foundation

public final class AuthenticationRepositoryImpl: AuthenticationRepository {

    private let apiService: ApiService?
    private let database: PocketGoodsDatabaseManager?
    private let cryptoService: CryptoService?

    public init(
        apiService: ApiService?,
        database: PocketGoodsDatabaseManager?,
        cryptoService: CryptoService?
    ) {
        self.apiService = apiService
        self.database = database
        self.cryptoService = cryptoService
    }

    public func login(email: String, password: String) async throws
        -> AnyPublisher<User?, ApiError>
    {
        guard
            let apiService,
            let database,
            let cryptoService
        else {
            return Fail(error: ApiError.missingDependencies)
                .eraseToAnyPublisher()
        }

        do {
            let formData = try JSONSerialization.data(
                withJSONObject: [
                    "email": email,
                    "password": password,
                ],
                options: []
            )

            let response = try await apiService.post(
                endPoint: "login",
                of: LoginResponseDTO.self,
                data: formData
            )

            cryptoService.saveTokenToKeychain(token: response.token)

            let user = response.user
            let wishlist = user.wishlist

            try database.insert(
                user.toUserEntity(),
                onConflict: .replace
            )

            try wishlist.forEach { itemDTO in
                if let productDetail = itemDTO.productDetail {
                    try database.insert(
                        productDetail.toProductEntity(),
                        onConflict: .replace
                    )

                    try productDetail.media.forEach { imageDTO in
                        try database.insert(
                            imageDTO.toImageEntity(productId: productDetail.id),
                            onConflict: .replace
                        )
                    }
                }

                try database.insert(
                    itemDTO.toWishlistItemEntity(userId: user.id),
                    onConflict: .replace
                )
            }

            return
                try database
                .streamUser(userId: user.id)
                .setFailureType(to: ApiError.self)
                .eraseToAnyPublisher()

        } catch {
            throw error
        }
    }

    public func register(
        fullName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) async throws -> String {
        guard let apiService else { throw ApiError.missingDependencies }

        let formData = try JSONSerialization.data(
            withJSONObject: [
                "name": fullName,
                "email": email,
                "password": password,
                "password_confirmation": passwordConfirmation,
            ],
            options: []
        )

        return try await apiService.put(
            endPoint: "register",
            of: String.self,
            data: formData
        )
    }

    public func getAuthenticatedUser() async -> AnyPublisher<
        Resource<User?>, ApiError
    > {
        guard let apiService,
            let database,
            let cryptoService
        else {
            return Fail(error: ApiError.missingDependencies)
                .eraseToAnyPublisher()
        }

        let loading = Just<Resource<User?>>(.loading(data: nil))
            .setFailureType(to: ApiError.self)

        var successOrError: AnyPublisher<Resource<User?>, ApiError>

        do {
            guard try await database.getCachedUserData() != nil else {
                successOrError = Just<Resource<User?>>(
                    .error(data: nil, error: ApiError.noDataError)
                )
                .setFailureType(to: ApiError.self)
                .eraseToAnyPublisher()

                return
                    Publishers
                    .Merge(loading, successOrError)
                    .eraseToAnyPublisher()
            }

            if let token = cryptoService.loadTokenFromKeychain(),
                !token.isEmpty
            {
                let userDTO = try await apiService.get(
                    endPoint: "user/is-authenticated",
                    of: UserDTO.self,
                    headers: [
                        "Authorization": "Bearer \(token)"
                    ]
                )

                try database.insert(
                    userDTO.toUserEntity(),
                    onConflict: .replace
                )

                try userDTO.wishlist.forEach { itemDTO in
                    if let productDetail = itemDTO.productDetail {
                        try database.insert(
                            productDetail.toProductEntity(),
                            onConflict: .replace
                        )
                        try productDetail.media.forEach { imageDTO in
                            try database.insert(
                                imageDTO.toImageEntity(
                                    productId: productDetail.id
                                ),
                                onConflict: .replace
                            )
                        }
                    }
                    try database
                        .insert(
                            itemDTO.toWishlistItemEntity(userId: userDTO.id),
                            onConflict: .replace
                        )
                }

                successOrError =
                    try database
                    .streamUser(userId: userDTO.id)
                    .map { Resource.success(data: $0) }
                    .setFailureType(to: ApiError.self)
                    .eraseToAnyPublisher()
            } else {
                successOrError = Just<Resource<User?>>(
                    .error(data: nil, error: ApiError.noDataError)
                )
                .setFailureType(to: ApiError.self)
                .eraseToAnyPublisher()
            }

        } catch {
            successOrError = Just<Resource<User?>>(
                .error(data: nil, error: ApiError.requestFailed(error))
            )
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
        }

        return
            Publishers
            .Merge(loading, successOrError)
            .eraseToAnyPublisher()
    }

    public func getCachedAuthenticatedUser(userId: Int64) throws
        -> AnyPublisher<User?, ApiError>
    {
        guard let database else {
            return Fail(error: ApiError.missingDependencies)
                .eraseToAnyPublisher()
        }

        return
            try database
            .streamUser(userId: userId)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }

    public func logout(userId: Int64) async throws -> Bool {
        guard let apiService,
            let database,
            let cryptoService
        else { throw ApiError.missingDependencies }

        guard
            let cachedUser =
                try await database
                .getCachedUserData(),
            let token = cryptoService.loadTokenFromKeychain(),
            !token.isEmpty
        else {
            throw ApiError.noDataError
        }

        let response = try await apiService.get(
            endPoint: "logout",
            of: Bool.self,
            headers: ["Authorization": "Bearer \(token)"]
        )

        try database.deleteWhere(
            tableName: Constant.USERS_TABLE,
            arguments: ["id": cachedUser.id]
        )

        cryptoService.saveTokenToKeychain(token: "")

        return response
    }

    public func clearCachedUser() async {
        guard
            let cryptoService,
            let database,
            let cachedUser = try? await database.getCachedUserData()
        else {
            return
        }

        try? database.deleteWhere(
            tableName: Constant.USERS_TABLE,
            arguments: ["id": cachedUser.id]
        )

        cryptoService.saveTokenToKeychain(token: "")
    }

}
