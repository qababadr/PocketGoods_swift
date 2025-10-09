//
//  LoginUseCase.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//

import Foundation
import CoreApp
import Combine

public final class LoginUseCase {

    private let repository: AuthenticationRepository?

    public init(repository: AuthenticationRepository?) {
        self.repository = repository
    }

    public func callAsFunction(
        email: String,
        password: String
    ) async throws -> AnyPublisher<User?, ApiError> {
        guard let repository = repository else {
            return Fail(error: ApiError.missingDependencies)
                .eraseToAnyPublisher()
        }
        return try await repository.login(
            email: email,
            password: password
        )
    }
}
