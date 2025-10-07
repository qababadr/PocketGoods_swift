//
//  ProductFeatureDomainModule.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-06.
//
import CoreApp
import Swinject

public struct ProductFeatureDomainModule {
    private init() {}

    public static func install() {
        AppContainer
            .shared
            .register(ProductRepository.self) {
                ProductFeatureDomainModule.provideProductRepository(
                    resolver: $0
                )
            }

        AppContainer
            .shared
            .register(ProductUseCases.self) {
                provideProductUseCases(resolver: $0)
            }
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
}
