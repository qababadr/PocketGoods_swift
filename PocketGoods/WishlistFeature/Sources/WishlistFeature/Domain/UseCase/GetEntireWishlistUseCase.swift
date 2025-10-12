//
//  GetEntireWishlistUseCase.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-10.
//

import Combine
import CoreApp
import Foundation

public final class GetEntireWishlistUseCase {

    private let repository: WishlistRepository?

    public init(repository: WishlistRepository?) {
        self.repository = repository
    }

    public func callAsFunction() async -> AnyPublisher<
        Resource<[WishlistItem]>, ApiError
    > {
        guard let repository else {
            return Fail(error: ApiError.missingDependencies)
                .eraseToAnyPublisher()
        }
        return await repository.getEntireWishlist()
    }
}
