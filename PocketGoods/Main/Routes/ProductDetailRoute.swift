//
//  ProductDetailRoute.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//

import AuthenticationFeature
import CoreApp
import CoreUI
import ProductFeature
import SwiftUI

struct ProductDetailRoute: View {
    let productId: Int64
    let productState: ProductState
    let onProductEvent: (ProductEvent) -> Void
    let authState: AuthState
    let onPocketGoodsAppEvent: (PocketGoodsAppEvent) -> Void

    init(
        productId: Int64,
        productState: ProductState,
        onProductEvent: @escaping (ProductEvent) -> Void,
        authState: AuthState,
        onPocketGoodsAppEvent: @escaping (PocketGoodsAppEvent) -> Void
    ) {
        self.productId = productId
        self.productState = productState
        self.onProductEvent = onProductEvent
        self.authState = authState
        self.onPocketGoodsAppEvent = onPocketGoodsAppEvent
    }

    @EnvironmentObject
    private var snackbarController: SnackbarController

    var body: some View {
        ProductDetailScreen(
            state: productState,
            productId: productId,
            onToggleWishlist: { productId, _ in
                if let authenticatedUser = authState.authenticatedUser {
                    onPocketGoodsAppEvent(
                        .onToggleWishlist(
                            userId: authenticatedUser.id,
                            productId: productId,
                            onAdded: {
                                snackbarController
                                    .show(
                                        message:
                                            LocalKeys
                                            .addedToWishlist
                                            .localized(
                                                bundle:
                                                    .coreUIBundle
                                            ),
                                        severity: .success
                                    )
                            },
                            onRemoved: {
                                snackbarController
                                    .show(
                                        message:
                                            LocalKeys
                                            .removedFromWishlist
                                            .localized(
                                                bundle:
                                                    .coreUIBundle
                                            ),
                                        severity: .success
                                    )
                            }
                        )
                    )
                } else {
                    snackbarController
                        .show(
                            message:
                                LocalKeys
                                .unauthorizedText
                                .localized(
                                    bundle:
                                        .coreUIBundle
                                ),
                            severity: .error
                        )
                }
            },
            onEvent: onProductEvent,
            authenticatedUser: authState.authenticatedUser
        )
    }
}
