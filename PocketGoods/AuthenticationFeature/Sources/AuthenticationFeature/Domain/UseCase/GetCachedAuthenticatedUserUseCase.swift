//
//  GetCachedAuthenticatedUserUseCase.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-06-03.
//

import Combine
import CoreApp
import Foundation

public final class GetCachedAuthenticatedUserUseCase {

    private let repository: AuthenticationRepository?

    public init(repository: AuthenticationRepository?) {
        self.repository = repository
    }

    public func callAsFunction(userId: Int64) throws -> AnyPublisher<
        User?, ApiError
    > {
        guard let repository else {
            return Fail(error: ApiError.missingDependencies)
                .eraseToAnyPublisher()
        }
        return
            try repository
            .getCachedAuthenticatedUser(userId: userId)
    }
}
