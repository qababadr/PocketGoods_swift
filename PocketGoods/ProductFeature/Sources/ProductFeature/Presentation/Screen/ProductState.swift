//
//  ProductState.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-07.
//
import CoreApp

public struct ProductState {
    public let products: [ProductPreview]
    public let lastPage: Int
    public let isPageLoading: Bool
    public let currentPage: Int
    public let error: Error?
    public let isSearching: Bool
    public let product: Product?
    public let suggestedProducts: [ProductPreview]

    public init(
        products: [ProductPreview] = [],
        lastPage: Int = 1,
        isPageLoading: Bool = true,
        currentPage: Int = 1,
        error: Error? = nil,
        isSearching: Bool = false,
        product: Product? = nil,
        suggestedProducts: [ProductPreview] = []
    ) {
        self.products = products
        self.lastPage = lastPage
        self.isPageLoading = isPageLoading
        self.currentPage = currentPage
        self.error = error
        self.isSearching = isSearching
        self.product = product
        self.suggestedProducts = suggestedProducts
    }

    public func copy(
        products: [ProductPreview]? = nil,
        lastPage: Int? = nil,
        isPageLoading: Bool? = nil,
        currentPage: Int? = nil,
        error: Error?? = nil,
        isSearching: Bool? = nil,
        product: Product?? = nil,
        suggestedProducts: [ProductPreview]? = nil
    ) -> ProductState {
        return ProductState(
            products: products ?? self.products,
            lastPage: lastPage ?? self.lastPage,
            isPageLoading: isPageLoading ?? self.isPageLoading,
            currentPage: currentPage ?? self.currentPage,
            error: error ?? self.error,
            isSearching: isSearching ?? self.isSearching,
            product: product ?? self.product,
            suggestedProducts: suggestedProducts ?? self.suggestedProducts
        )
    }
}
