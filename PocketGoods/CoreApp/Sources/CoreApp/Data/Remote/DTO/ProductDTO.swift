//
//  ProductDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct ProductDTO: Sendable, Codable {
    public let id: Int64
    public let title: String
    public let category: String
    public let price: Double
    public let quantity: Int
    public let description: String
    public let media: [ImageDTO]

    public init(
        id: Int64,
        title: String,
        category: String,
        price: Double,
        quantity: Int,
        description: String,
        media: [ImageDTO]
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.price = price
        self.quantity = quantity
        self.description = description
        self.media = media
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, category, price, quantity, description, media
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.category = try container.decode(String.self, forKey: .category)

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

        self.quantity = try container.decode(Int.self, forKey: .quantity)
        self.description = try container.decode(
            String.self,
            forKey: .description
        )
        self.media = try container.decode([ImageDTO].self, forKey: .media)
    }
    
    public static func empty() -> ProductDTO {
        return .init(
            id: 0,
            title: "",
            category: "",
            price: 0,
            quantity: 0,
            description: "",
            media: []
        )
    }
}
