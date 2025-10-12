//
//  WishlistRepository.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-10.
//

import Combine
import CoreApp

public protocol WishlistRepository {

    func toggleWishlist(
        userId: Int64,
        productId: Int64
    ) async throws -> Int64

    func getEntireWishlist() async -> AnyPublisher<
        Resource<[WishlistItem]>, ApiError
    >
}
