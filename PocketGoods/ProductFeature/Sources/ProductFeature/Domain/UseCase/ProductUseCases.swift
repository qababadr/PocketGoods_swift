//
//  ProductUseCases.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-06.
//

public struct ProductUseCases {
    public let getProducts: GetProductsUseCase
    public let getProduct: GetProductUseCase
    public let getSuggestedProducts: GetSuggestedProductsUseCase
    public let searchProducts: SearchProductsUseCase

    public init(
        getProducts: GetProductsUseCase,
        getProduct: GetProductUseCase,
        getSuggestedProducts: GetSuggestedProductsUseCase,
        searchProducts: SearchProductsUseCase
    ) {
        self.getProducts = getProducts
        self.getProduct = getProduct
        self.getSuggestedProducts = getSuggestedProducts
        self.searchProducts = searchProducts
    }
}
