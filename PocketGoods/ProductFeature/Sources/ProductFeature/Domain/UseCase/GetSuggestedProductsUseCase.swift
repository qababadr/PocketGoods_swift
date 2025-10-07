//
//  GetSuggestedProductsUseCase.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-06.
//

import Combine
import CoreApp
import Foundation

public final class GetSuggestedProductsUseCase {

    private let repository: ProductRepository?

    public init(repository: ProductRepository?) {
        self.repository = repository
    }

    public func callAsFunction(query: String) async -> AnyPublisher<
        Resource<[ProductPreview]>, Never
    > {
        guard let repository else {
            return Just(
                Resource<[ProductPreview]>.error(
                    data: nil,
                    error: NSError(domain: "Repository not found", code: -1)
                )
            )
            .eraseToAnyPublisher()
        }
        return await repository.getSuggestedProducts(query: query)
    }
}
