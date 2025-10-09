//
//  AuthState.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//

import CoreApp

public struct AuthState: Comparable {
    public static func < (lhs: AuthState, rhs: AuthState) -> Bool {
        lhs.authenticatedUser == rhs.authenticatedUser
    }
    
    public let authenticatedUser: User?

    public init(authenticatedUser: User? = nil) {
        self.authenticatedUser = authenticatedUser
    }

    public func copy(
        authenticatedUser: Optional<User>? = nil
    ) -> AuthState {
        return AuthState(
            authenticatedUser: authenticatedUser ?? self.authenticatedUser
        )
    }
}
