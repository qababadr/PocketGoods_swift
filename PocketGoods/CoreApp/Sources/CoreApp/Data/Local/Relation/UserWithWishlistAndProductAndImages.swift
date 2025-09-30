//
//  UserWithWishlistAndProductAndImages.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

import GRDB

public struct UserWithWishlistAndProductAndImages: Sendable, Decodable, FetchableRecord {
    var user: UserEntity
    var wishlist: [WishlistWithProductAndImages]
}
