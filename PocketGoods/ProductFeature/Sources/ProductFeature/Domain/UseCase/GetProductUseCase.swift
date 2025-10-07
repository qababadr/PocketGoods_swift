//
//  GetProductUseCase.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-06.
//

import Combine
import CoreApp
import Foundation

public final class GetProductUseCase {

    private let repository: ProductRepository?

    public init(repository: ProductRepository?) {
        self.repository = repository
    }

    public func callAsFunction(id: Int64) async -> AnyPublisher<
        Resource<Product?>, Never
    > {
        guard let repository else {
            return Just(
                Resource<Product?>.error(
                    data: nil,
                    error: NSError(domain: "Repository not found", code: -1)
                )
            )
            .eraseToAnyPublisher()
        }

        return await repository.getProduct(id: id)
    }
}
