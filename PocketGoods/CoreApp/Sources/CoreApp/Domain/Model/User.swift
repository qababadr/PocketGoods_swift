//
//  User.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation

public struct User: Sendable, Codable, Equatable {
    public let id: Int64
    public let name: String
    public let email: String
    public let emailVerifiedAt: Date?
    public let wishlist: [WishlistItem]

    public init(
        id: Int64,
        name: String,
        email: String,
        emailVerifiedAt: Date?,
        wishlist: [WishlistItem]
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.emailVerifiedAt = emailVerifiedAt
        self.wishlist = wishlist
    }

    public func inWishlist(productId: Int64) -> Bool {
        return wishlist.contains(where: { $0.productId == productId })
    }
}
