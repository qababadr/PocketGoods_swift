//
//  RegisterUseCase.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-06-03.
//

import CoreApp
import Foundation

public final class RegisterUseCase {

    private let repository: AuthenticationRepository?

    public init(repository: AuthenticationRepository?) {
        self.repository = repository
    }

    public func callAsFunction(
        fullName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) async throws -> String {
        guard let repository else { throw ApiError.missingDependencies }
        return try await repository.register(
            fullName: fullName,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation
        )
    }
}
