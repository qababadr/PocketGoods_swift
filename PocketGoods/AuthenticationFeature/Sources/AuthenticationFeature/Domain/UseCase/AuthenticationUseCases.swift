//
//  AuthenticationUseCases.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//

public struct AuthenticationUseCases {
    public let login: LoginUseCase
    public let register: RegisterUseCase
    public let logout: LogoutUseCase
    public let clearCachedUser: ClearCachedUserUseCase
    public let getAuthenticatedUser: GetAuthenticatedUserUseCase
    public let getCachedAuthenticatedUser: GetCachedAuthenticatedUserUseCase

    public init(
        login: LoginUseCase,
        register: RegisterUseCase,
        logout: LogoutUseCase,
        clearCachedUser: ClearCachedUserUseCase,
        getAuthenticatedUser: GetAuthenticatedUserUseCase,
        getCachedAuthenticatedUser: GetCachedAuthenticatedUserUseCase
    ) {
        self.login = login
        self.register = register
        self.logout = logout
        self.clearCachedUser = clearCachedUser
        self.getAuthenticatedUser = getAuthenticatedUser
        self.getCachedAuthenticatedUser = getCachedAuthenticatedUser
    }
}
