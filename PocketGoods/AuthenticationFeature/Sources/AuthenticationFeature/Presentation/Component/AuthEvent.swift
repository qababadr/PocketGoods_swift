//
//  AuthEvent.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//
import CoreApp

public enum AuthEvent {
    case onRefreshUserData(
        onRefreshFailed: () -> Void
    )
    
    case setAuthenticatedUser(
        user: User?
    )
    
    case onLogout(
        userId: Int64,
        onLoggedOut: () -> Void,
        onError: () -> Void
    )
}
