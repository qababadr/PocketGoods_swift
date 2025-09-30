//
//  Product.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation

public struct Product: Sendable, Codable, Equatable {
    public let id: Int64
    public let title: String
    public let category: String
    public let price: Double
    public let quantity: Int
    public let description: String
    public let media: [Image]

    public init(
        id: Int64,
        title: String,
        category: String,
        price: Double,
        quantity: Int,
        description: String,
        media: [Image]
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.price = price
        self.quantity = quantity
        self.description = description
        self.media = media
    }

    public var inStock: Bool {
        quantity > 0
    }

    public func originalImages() -> [URL] {
        media.compactMap { URL(string: $0.original) }
    }
}
