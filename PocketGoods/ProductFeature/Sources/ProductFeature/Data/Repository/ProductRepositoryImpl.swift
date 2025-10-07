//
//  ProductRepositoryImpl.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-06.
//

import Combine
import CoreApp
import Foundation

public final class ProductRepositoryImpl: ProductRepository {

    private let apiService: ApiService?
    private let database: PocketGoodsDatabaseManager?

    public init(apiService: ApiService?, database: PocketGoodsDatabaseManager?)
    {
        self.apiService = apiService
        self.database = database
    }

    public func getProducts(page: Int) async -> AnyPublisher<
        Resource<PaginationResponse<ProductPreview>>,
        Never
    > {
        guard let apiService else {
            return Just(.loading(data: PaginationResponse.empty()))
                .eraseToAnyPublisher()
        }

        let loading = Just(
            Resource<PaginationResponse<ProductPreview>>.loading(
                data: PaginationResponse.empty()
            )
        )

        do {
            let response = try await apiService.rawGet(
                endPoint: "products?page=\(page)",
                of: PaginationResponseDTO<ProductPreviewDTO>.self
            )

            let data = response.toPaginationResponse(
                of: ProductPreview.self,
                to: { $0.toProductPreview() }
            )

            let success = Just(
                Resource<PaginationResponse<ProductPreview>>.success(
                    data: data
                )
            )

            return
                Publishers
                .Merge(loading, success)
                .eraseToAnyPublisher()

        } catch {
            let error = Just(
                Resource<PaginationResponse<ProductPreview>>.error(
                    data: PaginationResponse.empty(),
                    error: error
                )
            )

            return
                Publishers
                .Merge(loading, error)
                .eraseToAnyPublisher()
        }
    }

    public func getProduct(id: Int64) async -> AnyPublisher<
        Resource<Product?>, Never
    > {
        guard let apiService,
            let database
        else {
            return Just(.loading(data: nil))
                .eraseToAnyPublisher()
        }

        var loading: Just<Resource<Product?>>

        do {
            let productWithImage: ProductWithImages? = try await database.reader
                .read { db in
                    try ProductEntity
                        .including(all: ProductEntity.images)
                        .filter(id: id)
                        .asRequest(of: ProductWithImages.self)
                        .fetchOne(db)
                }

            loading = Just(
                Resource<Product?>.loading(data: productWithImage?.toProduct())
            )

        } catch {
            loading = Just(Resource<Product?>.loading(data: nil))
        }

        do {
            let response = try await apiService.get(
                endPoint: "product/details/\(id)",
                of: ProductDTO.self
            )

            try database.insert(
                response.toProductEntity(),
                onConflict: .replace
            )

            try response.media.forEach { imageDTO in
                try database.insert(
                    imageDTO.toImageEntity(productId: response.id),
                    onConflict: .replace
                )
            }

            let success = Just(
                Resource<Product?>.success(data: response.toProduct())
            )

            return
                Publishers
                .Merge(loading, success)
                .eraseToAnyPublisher()

        } catch {
            let error = Just(Resource<Product?>.error(data: nil, error: error))
            return
                Publishers
                .Merge(loading, error)
                .eraseToAnyPublisher()
        }

    }

    public func getSuggestedProducts(query: String) async -> AnyPublisher<
        Resource<[ProductPreview]>, Never
    > {
        guard let apiService else {
            return Just(.loading(data: []))
                .eraseToAnyPublisher()
        }

        let loading = Just(Resource<[ProductPreview]>.loading(data: []))

        do {

            let formData = try JSONSerialization.data(
                withJSONObject: [
                    "search_query": query
                ],
                options: []
            )

            let response = try await apiService.post(
                endPoint: "product/search-suggestions",
                of: [ProductPreviewDTO].self,
                data: formData
            )

            let products = response.map { $0.toProductPreview() }

            let success = Just(
                Resource<[ProductPreview]>.success(data: products)
            )

            return
                Publishers
                .Merge(loading, success)
                .eraseToAnyPublisher()

        } catch {
            let error = Just(
                Resource<[ProductPreview]>.error(data: [], error: error)
            )
            return
                Publishers
                .Merge(loading, error)
                .eraseToAnyPublisher()
        }
    }

    public func searchProducts(query: String, page: Int) async -> AnyPublisher<
        Resource<CoreApp.PaginationResponse<ProductPreview>>,
        Never
    > {
        guard let apiService else {
            return Just(.loading(data: PaginationResponse.empty()))
                .eraseToAnyPublisher()
        }

        let loading = Just(
            Resource<PaginationResponse<ProductPreview>>.loading(
                data: PaginationResponse.empty()
            )
        )

        do {

            let formData = try JSONSerialization.data(
                withJSONObject: ["search_query": query],
                options: []
            )

            let response = try await apiService.rawPost(
                endPoint: "product/search?=\(page)",
                of: PaginationResponseDTO<ProductPreviewDTO>.self,
                data: formData
            )

            let data = response.toPaginationResponse(
                of: ProductPreview.self,
                to: { $0.toProductPreview() }
            )

            let success = Just(
                Resource<PaginationResponse<ProductPreview>>.success(data: data)
            )

            return
                Publishers
                .Merge(loading, success)
                .eraseToAnyPublisher()

        } catch {
            let error = Just(
                Resource<PaginationResponse<ProductPreview>>.error(
                    data: PaginationResponse.empty(),
                    error: error
                )
            )
            return
                Publishers
                .Merge(loading, error)
                .eraseToAnyPublisher()
        }
    }

}
