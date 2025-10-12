//
//  WishlistFeatureDomainModule.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-10.
//

import CoreApp
import Swinject

public struct WishlistFeatureDomainModule {
    private init() {}
    
    public static func install() {
        AppContainer
            .shared
            .register(WishlistRepository.self) {
                WishlistFeatureDomainModule
                    .provideWishlistRepository(
                        resolver: $0
                    )
            }

        AppContainer
            .shared
            .register(WishlistUseCases.self) {
                WishlistFeatureDomainModule.provideWishlistUseCases(
                    resolver: $0
                )
            }
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
}
