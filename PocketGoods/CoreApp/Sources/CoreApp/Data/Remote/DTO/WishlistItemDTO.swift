//
//  WishlistItemDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct WishlistItemDTO: Sendable, Codable {
    public let id: Int64
    public let productId: Int64?
    public let productDetail: ProductDTO?

    public init(id: Int64, productId: Int64?, productDetail: ProductDTO?) {
        self.id = id
        self.productId = productId
        self.productDetail = productDetail
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case productDetail = "product_detail"
    }
}
