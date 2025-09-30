//
//  ProductPreviewDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct ProductPreviewDTO: Sendable, Codable {
    public let id: Int64
    public let title: String
    public let category: String
    public let price: Double
    public let thumbnail: String?

    public init(
        id: Int64,
        title: String,
        category: String,
        price: Double,
        thumbnail: String?
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.price = price
        self.thumbnail = thumbnail
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, category, price, thumbnail
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.category = try container.decode(String.self, forKey: .category)
        self.thumbnail = try container.decodeIfPresent(
            String.self,
            forKey: .thumbnail
        )

        if let doublePrice = try? container.decode(Double.self, forKey: .price)
        {
            price = doublePrice
        } else if let stringPrice = try? container.decode(
            String.self,
            forKey: .price
        ), let doubleFromString = Double(stringPrice) {
            price = doubleFromString
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .price,
                in: container,
                debugDescription: "Price value is not Double or String"
            )
        }
    }
}
