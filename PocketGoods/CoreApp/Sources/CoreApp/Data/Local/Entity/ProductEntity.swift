//
//  ProductEntity.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

import GRDB

public struct ProductEntity:
    Sendable,
    Identifiable,
    Codable,
    FetchableRecord,
    PersistableRecord
{
    public var id: Int64
    public var title: String
    public var category: String
    public var price: Double
    public var quantity: Int
    public var description: String
    public static let images = hasMany(
        ImageEntity.self,
        key: "images",
        using: ForeignKey(["model_id"], to: ["id"])
    )
    public var images: QueryInterfaceRequest<ImageEntity> {
        request(for: ProductEntity.images)
    }
    
    public static var databaseTableName: String { Constant.PRODUCTS_TABLE }

    enum CodingKeys: String, CodingKey {
        case id, title, category, price, quantity, description

    }

    mutating public func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }

    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let title = Column(CodingKeys.title)
        static let category = Column(CodingKeys.category)
        static let price = Column(CodingKeys.price)
        static let quantity = Column(CodingKeys.quantity)
        static let description = Column(CodingKeys.description)
    }
}
