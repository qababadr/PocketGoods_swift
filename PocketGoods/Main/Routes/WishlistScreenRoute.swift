//
//  WishlistScreenRoute.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//

import AuthenticationFeature
import CoreApp
import CoreUI
import ProductFeature
import SwiftUI
import WishlistFeature

struct WishlistScreenRoute: View {

    private let authState: AuthState

    @Binding
    private var wishlistScreenState: WishlistManagerState

    private let onPocketGoodsAppEvent: (PocketGoodsAppEvent) -> Void

    private let onWishlistManagerScreenEvent:
        (WishlistManagerScreenEvent) -> Void

    @EnvironmentObject
    private var snackbarController: SnackbarController

    @EnvironmentObject
    private var router: Router

    @EnvironmentObject
    private var modalController: ModalController

    init(
        authState: AuthState,
        wishlistScreenState: Binding<WishlistManagerState>,
        onPocketGoodsAppEvent: @escaping (PocketGoodsAppEvent) -> Void,
        onWishlistManagerScreenEvent: @escaping (WishlistManagerScreenEvent) ->
            Void
    ) {
        self.authState = authState
        _wishlistScreenState = wishlistScreenState
        self.onPocketGoodsAppEvent = onPocketGoodsAppEvent
        self.onWishlistManagerScreenEvent = onWishlistManagerScreenEvent
    }

    var body: some View {
        WishlistManagerScreen(
            state: $wishlistScreenState,
            onEvent: onWishlistManagerScreenEvent,
            onDeleteSuccess: { productTitle in
                modalController.dismiss()
                snackbarController.show(
                    message: LocalKeys
                        .removedFromWishlist
                        .localized(
                            bundle: .coreUIBundle,
                            productTitle
                        ),
                    severity: .success
                )
            },
            onDeleteError: { productTitle in
                modalController.dismiss()
                snackbarController.show(
                    message: LocalKeys
                        .removeFromWishlistError
                        .localized(
                            bundle: .coreUIBundle,
                            productTitle
                        ),
                    severity: .error
                )
            },
            onProductClick: { productId in
                router.navigate(
                    to: .ProductDetailScreen(
                        productId: productId
                    ),
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
            },
            authenticatedUser: authState.authenticatedUser
        )
    }
}
