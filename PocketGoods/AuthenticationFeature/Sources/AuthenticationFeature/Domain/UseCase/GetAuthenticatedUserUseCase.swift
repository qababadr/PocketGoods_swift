//
//  GetAuthenticatedUserUseCase.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-06-03.
//

import Combine
import CoreApp
import Foundation

public final class GetAuthenticatedUserUseCase {

    private let repository: AuthenticationRepository?

    public init(repository: AuthenticationRepository?) {
        self.repository = repository
    }

    public func callAsFunction() async -> AnyPublisher<
        Resource<User?>, ApiError
    > {
        guard let repository else {
            return Just(
                Resource<User?>.error(
                    data: nil,
                    error: ApiError.missingDependencies
                )
            )
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
        }
        return await repository.getAuthenticatedUser()
    }
}
