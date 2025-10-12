//
//  WishlistManagerScreenEvent.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-11.
//

public enum WishlistManagerScreenEvent {
    case getWishlistItems(userId: Int64)

    case deleteWishlistItem(
        userId: Int64,
        productId: Int64,
        onSuccess: () -> Void,
        onError: (Error?) -> Void
    )
}
