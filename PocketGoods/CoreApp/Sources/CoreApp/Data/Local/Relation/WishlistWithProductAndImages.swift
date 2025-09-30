//
//  WishlistWithProductAndImages.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

import GRDB

public struct WishlistWithProductAndImages: Sendable, Decodable, FetchableRecord {
    public var wishlist: WishlistItemEntity
    public var productWithImages: ProductWithImages?
}
