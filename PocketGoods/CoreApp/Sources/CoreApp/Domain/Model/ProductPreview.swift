//
//  ProductPreview.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//


public struct ProductPreview: Codable, Equatable, Identifiable {
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
}
