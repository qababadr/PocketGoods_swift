//
//  AuthenticationFeatureDomainModule.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//
import CoreApp
import Swinject

public struct AuthenticationFeatureDomainModule {

    private init() {}

    public static func install() {
        AppContainer
            .shared
            .register(AuthenticationRepository.self) {
                AuthenticationFeatureDomainModule
                    .provideAuthenticationRepository(
                        resolver: $0
                    )
            }
        
        AppContainer
            .shared
            .register(AuthenticationUseCases.self) {
                AuthenticationFeatureDomainModule.provideAuthenticationUseCases(
                    resolver: $0
                )
            }
    }

    private static func provideAuthenticationRepository(resolver: Resolver)
        -> AuthenticationRepository
    {
        return AuthenticationRepositoryImpl(
            apiService: resolver.resolve(ApiService.self),
            database: resolver.resolve(PocketGoodsDatabaseManager.self),
            cryptoService: resolver.resolve(CryptoService.self)
        )
    }

    private static func provideAuthenticationUseCases(resolver: Resolver)
        -> AuthenticationUseCases
    {
        let repository = resolver.resolve(AuthenticationRepository.self)
        return AuthenticationUseCases(
            login: LoginUseCase(repository: repository),
            register: RegisterUseCase(repository: repository),
            logout: LogoutUseCase(repository: repository),
            clearCachedUser: ClearCachedUserUseCase(repository: repository),
            getAuthenticatedUser: GetAuthenticatedUserUseCase(
                repository: repository
            ),
            getCachedAuthenticatedUser: GetCachedAuthenticatedUserUseCase(
                repository: repository
            )
        )
    }
}
