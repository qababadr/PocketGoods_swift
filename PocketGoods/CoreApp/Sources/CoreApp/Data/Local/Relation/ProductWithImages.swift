//
//  ProductWithImages.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import GRDB

public struct ProductWithImages: Sendable, Decodable, FetchableRecord {
    public var product: ProductEntity
    public var images: [ImageEntity]
}
