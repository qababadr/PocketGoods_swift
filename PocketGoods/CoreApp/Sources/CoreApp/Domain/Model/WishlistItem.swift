//
//  WishlistItem.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//


public struct WishlistItem: Sendable, Codable, Equatable {
    public let id: Int64
    public let productId: Int64?
    public let productDetail: Product?

    public init(id: Int64, productId: Int64?, productDetail: Product?) {
        self.id = id
        self.productId = productId
        self.productDetail = productDetail
    }
}
