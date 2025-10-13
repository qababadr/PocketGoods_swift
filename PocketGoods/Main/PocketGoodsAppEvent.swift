//
//  PocketGoodsAppEvent.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-12.
//
import CoreApp
import CoreUI

enum PocketGoodsAppEvent {
    case onLoadData(
        onSuccess: (User?) -> Void,
        onError: () -> Void
    )

    case authCheck(
        onUnAuthenticated: () -> Void
    )

    case onSetDarkTheme(isDarkTheme: Bool)

    case onSetCurrentDestination(destination: Destination)

    case onToggleWishlist(
        userId: Int64,
        productId: Int64,
        onAdded: () -> Void,
        onRemoved: () -> Void
    )
}
