//
//  WishlistUseCases.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-10.
//

public struct WishlistUseCases {
    public let getEntireWishlist: GetEntireWishlistUseCase
    public let toggleWishlist: ToggleWishlistUseCase

    public init(
        getEntireWishlist: GetEntireWishlistUseCase,
        toggleWishlist: ToggleWishlistUseCase
    ) {
        self.getEntireWishlist = getEntireWishlist
        self.toggleWishlist = toggleWishlist
    }
}
