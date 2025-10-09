//
//  ClearCachedUserUseCase.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-06-03.
//

import Foundation

public final class ClearCachedUserUseCase {

    private let repository: AuthenticationRepository?

    public init(repository: AuthenticationRepository?) {
        self.repository = repository
    }

    public func callAsFunction() async {
        guard let repository else { return }
        return await repository.clearCachedUser()
    }
}
