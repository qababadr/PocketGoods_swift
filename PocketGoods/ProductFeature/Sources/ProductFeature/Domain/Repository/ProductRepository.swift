import Combine
//
//  ProductRepository.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-06.
//
import CoreApp

public protocol ProductRepository {

    func getProducts(page: Int) async -> AnyPublisher<
        Resource<PaginationResponse<ProductPreview>>, Never
    >

    func getProduct(id: Int64) async -> AnyPublisher<Resource<Product?>, Never>

    func getSuggestedProducts(query: String) async -> AnyPublisher<
        Resource<[ProductPreview]>, Never
    >

    func searchProducts(query: String, page: Int) async -> AnyPublisher<
        Resource<PaginationResponse<ProductPreview>>, Never
    >

}
