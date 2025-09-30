//
//  WishlistResponseDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct WishlistResponseDTO: Sendable, Codable {
    public let inWishlist: Bool
    public let wishlistItemId: Int64
    public let product: ProductDTO?

    public init(inWishlist: Bool, wishlistItemId: Int64, product: ProductDTO?) {
        self.inWishlist = inWishlist
        self.wishlistItemId = wishlistItemId
        self.product = product
    }

    private enum CodingKeys: String, CodingKey {
        case inWishlist = "in_wishlist"
        case wishlistItemId = "wishlist_item_id"
        case product
    }

    public static func empty() -> Self {
        return .init(
            inWishlist: false,
            wishlistItemId: 0,
            product: nil
        )
    }
}
