//
//  RouteBuilder.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//
import SwiftUI
import CoreUI

extension Layout {

    @ViewBuilder
    func buildRoutes(destination: Destination) -> some View {
        switch destination {
        case .HomeScreen:
            HomeRoute(
                authState: authState,
                productState: productState,
                onProductEvent: onProductEvent,
                onPocketGoodsAppEvent: onPocketGoodsAppEvent
            )

        case .ProductDetailScreen(let productId):
            ProductDetailRoute(
                productId: productId,
                productState: productState,
                onProductEvent: onProductEvent,
                authState: authState,
                onPocketGoodsAppEvent: onPocketGoodsAppEvent
            )

        case .ProductSearchResultScreen:
            ProductSearchRoute(
                authState: authState,
                productState: productState,
                onProductEvent: onProductEvent,
                onPocketGoodsAppEvent: onPocketGoodsAppEvent
            )

        case .WishlistManagerScreen:
            WishlistScreenRoute(
                authState: authState,
                wishlistScreenState: $wishlistManagerState,
                onPocketGoodsAppEvent: onPocketGoodsAppEvent,
                onWishlistManagerScreenEvent:
                    onWishlistManagerScreenEvent
            )

        case .UnAuthorizedScreen:
            Page401(onBackHomeClick: {
                router.navigate(
                    to: .HomeScreen,
                    onNavigate: { destination in
                        if let destination {
                            onPocketGoodsAppEvent(
                                .onSetCurrentDestination(
                                    destination: destination
                                )
                            )
                        }
                    }
                )
            })
        }
    }
}
