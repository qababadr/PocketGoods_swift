//
//  WishlistRepositoryImpl.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-10.
//
import Combine
import CoreApp

public final class WishlistRepositoryImpl: WishlistRepository {

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

    public func toggleWishlist(userId: Int64, productId: Int64) async throws
        -> Int64
    {
        guard let apiService,
            let database,
            let cryptoService
        else { throw ApiError.missingDependencies }

        guard try await database.getCachedUserData() != nil,
            let token = cryptoService.loadTokenFromKeychain(),
            !token.isEmpty
        else {
            throw ApiError.noDataError
        }

        let response = try await apiService.get(
            endPoint: "wishlist/toggle/\(productId)",
            of: WishlistResponseDTO.self,
            headers: ["Authorization": "Bearer \(token)"]
        )

        if response.wishlistItemId == -1 {
            try database.deleteWhere(
                tableName: Constant.WISHLIST_TABLE,
                arguments: [
                    "id": productId,
                    "user_id": userId,
                ]
            )
        } else {
            if let product = response.product {
                try database.insert(
                    product.toProductEntity(),
                    onConflict: .replace
                )
                try product
                    .media
                    .forEach { imageDTO in
                        try database.insert(
                            imageDTO.toImageEntity(
                                productId: product.id
                            ),
                            onConflict: .replace
                        )
                    }
                try database.insert(
                    WishlistItemEntity(
                        id: response.wishlistItemId,
                        productId: productId,
                        userId: userId
                    ),
                    onConflict: .replace
                )

            }
        }

        return response.wishlistItemId
    }

    public func getEntireWishlist() async -> AnyPublisher<
        Resource<[WishlistItem]>, ApiError
    > {
        guard let apiService,
            let database,
            let cryptoService
        else {
            return Fail(error: ApiError.missingDependencies)
                .eraseToAnyPublisher()
        }

        do {
            guard let cachedUser = try await database.getCachedUserData(),
                let token = cryptoService.loadTokenFromKeychain(),
                !token.isEmpty
            else {
                return Fail(error: ApiError.noDataError)
                    .eraseToAnyPublisher()
            }

            let loading = Just<Resource<[WishlistItem]>>(
                .loading(data: cachedUser.wishlist)
            ).setFailureType(to: ApiError.self)

            let list = try await apiService.get(
                endPoint: "wishlist/list",
                of: [WishlistItemDTO].self,
                headers: ["Authorization": "Bearer \(token)"]
            )

            try list.forEach { dto in
                if let productDTO = dto.productDetail {
                    try database.insert(
                        productDTO.toProductEntity(),
                        onConflict: .replace
                    )
                    try productDTO.media.forEach { media in
                        try database.insert(
                            media.toImageEntity(productId: productDTO.id),
                            onConflict: .replace
                        )
                    }
                }

                try database.insert(
                    dto.toWishlistItemEntity(userId: cachedUser.id),
                    onConflict: .replace
                )
            }

            let success =
                try database
                .streamUser(userId: cachedUser.id)
                .compactMap { $0 }
                .map { user in
                    Resource.success(data: user.wishlist)
                }
                .setFailureType(to: ApiError.self)

            return
                Publishers
                .Merge(loading, success)
                .eraseToAnyPublisher()

        } catch {
            return Fail(error: ApiError.requestFailed(error))
                .eraseToAnyPublisher()
        }
    }

}
