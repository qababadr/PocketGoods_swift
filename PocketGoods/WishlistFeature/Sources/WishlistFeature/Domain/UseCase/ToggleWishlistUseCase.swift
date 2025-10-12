//
//  ToggleWishlistUseCase.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-10.
//

import CoreApp
import Foundation

public final class ToggleWishlistUseCase {

    private let repository: WishlistRepository?

    public init(repository: WishlistRepository?) {
        self.repository = repository
    }

    public func callAsFunction(
        userId: Int64,
        productId: Int64
    ) async throws -> Int64 {
        guard let repository else { throw ApiError.missingDependencies }
        return try await repository.toggleWishlist(
            userId: userId,
            productId: productId
        )
    }
}
