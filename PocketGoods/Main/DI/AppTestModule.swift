//
//  AppTestModule.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//

import AuthenticationFeature
import CoreApp
import ProductFeature
import SettingsFeature
import Swinject
import WishlistFeature

public struct AppTestModule {
    private init() {}

    public static func install() {
        AppContainer
            .shared
            .register(ApiService.self) {
                AppTestModule.provideApiService(resolver: $0)
            }

        AppContainer
            .shared
            .register(PocketGoodsDatabaseManager.self) {
                AppTestModule.provideDatabaseManager(resolver: $0)
            }

        AppContainer
            .shared
            .register(CryptoService.self) {
                AppTestModule.provideCryptoService(resolver: $0)
            }

        AppContainer
            .shared
            .register(ProductRepository.self) {
                AppTestModule.provideProductRepository(
                    resolver: $0
                )
            }

        AppContainer
            .shared
            .register(ProductUseCases.self) {
                AppTestModule.provideProductUseCases(resolver: $0)
            }

        AppContainer
            .shared
            .register(AuthenticationRepository.self) {
                AppTestModule
                    .provideAuthenticationRepository(
                        resolver: $0
                    )
            }

        AppContainer
            .shared
            .register(AuthenticationUseCases.self) {
                AppTestModule.provideAuthenticationUseCases(
                    resolver: $0
                )
            }

        AppContainer
            .shared
            .register(WishlistRepository.self) {
                AppTestModule
                    .provideWishlistRepository(
                        resolver: $0
                    )
            }

        AppContainer
            .shared
            .register(WishlistUseCases.self) {
                AppTestModule.provideWishlistUseCases(
                    resolver: $0
                )
            }

        AppContainer
            .shared
            .register(ApplicationSettingsRepository.self) {
                AppTestModule
                    .provideApplicationSettingsRepository(
                        resolver: $0
                    )
            }

        AppContainer
            .shared
            .register(ApplicationSettingsUseCases.self) {
                AppTestModule
                    .provideApplicationSettingsUseCases(
                        resolver: $0
                    )
            }
    }

    private static func provideApiService(resolver: Resolver) -> ApiService {
        return ApiServiceBuilder()
            .timeout(timeout: Constant.REQUEST_TIMEOUT)
            .session(session: MockURLProtocol.makeSession())
            .baseUrl(stringUrl: Constant.API_BASE_URL)
            .withLogger()
            .build()
    }

    private static func provideDatabaseManager(resolver: Resolver)
        -> PocketGoodsDatabaseManager
    {
        return PocketGoodsDatabaseBuilder()
            .eraseDatabaseOnSchemaChange(true)
            .inMemory(true)
            .migrationVersion("v1")
            .build()
    }

    private static func provideCryptoService(resolver: Resolver)
        -> CryptoService
    {
        return MockCryptoService()
    }

    private static func provideProductRepository(resolver: Resolver)
        -> ProductRepository
    {
        return ProductRepositoryImpl(
            apiService: resolver.resolve(ApiService.self),
            database: resolver.resolve(PocketGoodsDatabaseManager.self)
        )
    }

    private static func provideProductUseCases(resolver: Resolver)
        -> ProductUseCases
    {
        let repository = resolver.resolve(ProductRepository.self)
        return ProductUseCases(
            getProducts: GetProductsUseCase(repository: repository),
            getProduct: GetProductUseCase(repository: repository),
            getSuggestedProducts: GetSuggestedProductsUseCase(
                repository: repository
            ),
            searchProducts: SearchProductsUseCase(repository: repository)
        )
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

    private static func provideWishlistRepository(resolver: Resolver)
        -> WishlistRepository
    {
        return WishlistRepositoryImpl(
            apiService: resolver.resolve(ApiService.self),
            database: resolver.resolve(PocketGoodsDatabaseManager.self),
            cryptoService: resolver.resolve(CryptoService.self)
        )
    }

    private static func provideWishlistUseCases(resolver: Resolver)
        -> WishlistUseCases
    {
        let repository = resolver.resolve(WishlistRepository.self)
        return WishlistUseCases(
            getEntireWishlist: GetEntireWishlistUseCase(repository: repository),
            toggleWishlist: ToggleWishlistUseCase(repository: repository)
        )
    }

    private static func provideApplicationSettingsRepository(resolver: Resolver)
        -> ApplicationSettingsRepository
    {
        return ApplicationSettingsRepositoryImpl(
            database: resolver.resolve(PocketGoodsDatabaseManager.self)
        )
    }

    private static func provideApplicationSettingsUseCases(resolver: Resolver)
        -> ApplicationSettingsUseCases
    {
        let repository = resolver.resolve(ApplicationSettingsRepository.self)
        return ApplicationSettingsUseCases(
            getApplicationSettings: GetApplicationSettingsUseCase(
                repository: repository
            ),
            saveApplicationSettings: SaveApplicationSettingsUseCase(
                repository: repository
            )
        )
    }
}
