//
//  WishlistManagerState.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-11.
//
import CoreApp

public struct WishlistManagerState {
    public var isPageLoading: Bool
    public var isDeleting: Bool
    public var wishlist: [WishlistItem]
    public var error: Error?

    public init(
        isPageLoading: Bool = false,
        isDeleting: Bool = false,
        wishlist: [WishlistItem] = [],
        error: Error? = nil
    ) {
        self.isPageLoading = isPageLoading
        self.isDeleting = isDeleting
        self.wishlist = wishlist
        self.error = error
    }

    public func copy(
        isPageLoading: Bool? = nil,
        isDeleting: Bool? = nil,
        wishlist: [WishlistItem]? = nil,
        error: Error?? = nil
    ) -> WishlistManagerState {
        return WishlistManagerState(
            isPageLoading: isPageLoading ?? self.isPageLoading,
            isDeleting: isDeleting ?? self.isDeleting,
            wishlist: wishlist ?? self.wishlist,
            error: error ?? self.error
        )
    }
}
