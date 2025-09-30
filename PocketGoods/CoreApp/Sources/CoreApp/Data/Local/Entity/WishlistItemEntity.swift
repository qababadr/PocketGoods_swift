//
//  WishlistItemEntity.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

import GRDB

public struct WishlistItemEntity:
    Sendable,
    Identifiable,
    Codable,
    FetchableRecord,
    PersistableRecord
{
    public var id: Int64
    public var productId: Int64?
    public var userId: Int64
    public static let product = hasOne(
        ProductEntity.self,
        key: "productWithImages",
        using: ForeignKey(["id"], to: ["product_id"])
    )
    public var product: QueryInterfaceRequest<ProductEntity> {
        request(for: WishlistItemEntity.product)
    }
    
    public init(id: Int64, productId: Int64? = nil, userId: Int64) {
        self.id = id
        self.productId = productId
        self.userId = userId
    }

    public static var databaseTableName: String { Constant.WISHLIST_TABLE }

    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let productId = Column(CodingKeys.productId)
        static let userId = Column(CodingKeys.userId)
    }

    mutating public func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case userId = "user_id"
    }
}
