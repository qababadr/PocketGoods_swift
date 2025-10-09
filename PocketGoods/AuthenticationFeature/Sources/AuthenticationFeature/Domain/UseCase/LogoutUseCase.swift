//
//  LogoutUseCase.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-06-03.
//

import CoreApp
import Foundation

public final class LogoutUseCase {

    private let repository: AuthenticationRepository?

    public init(repository: AuthenticationRepository?) {
        self.repository = repository
    }

    public func callAsFunction(userId: Int64) async throws -> Bool {
        guard let repository else { throw ApiError.missingDependencies }
        return try await repository.logout(userId: userId)
    }
}
