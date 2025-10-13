//
//  ProductSearchRoute.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//

import AuthenticationFeature
import CoreApp
import CoreUI
import ProductFeature
import SwiftUI

struct ProductSearchRoute: View {

    let authState: AuthState
    let productState: ProductState
    let onProductEvent: (ProductEvent) -> Void
    let onPocketGoodsAppEvent: (PocketGoodsAppEvent) -> Void

    init(
        authState: AuthState,
        productState: ProductState,
        onProductEvent: @escaping (ProductEvent) -> Void,
        onPocketGoodsAppEvent: @escaping (PocketGoodsAppEvent) -> Void
    ) {
        self.authState = authState
        self.productState = productState
        self.onProductEvent = onProductEvent
        self.onPocketGoodsAppEvent = onPocketGoodsAppEvent
    }

    @EnvironmentObject
    private var router: Router

    @EnvironmentObject
    private var snackbarController: SnackbarController

    var body: some View {
        ProductSearchResultScreen(
            state: productState,
            onEvent: onProductEvent,
            onViewProduct: { productId in
                router.navigate(
                    to: .ProductDetailScreen(
                        productId: productId
                    ),
                    onNavigate: { destination in
                        if let destination {
                            onPocketGoodsAppEvent(
                                .onSetCurrentDestination(
                                    destination:
                                        destination
                                )
                            )
                        }
                    }
                )
            },
            onToggleWishlist: { productId, _ in
                if let authenticatedUser = authState
                    .authenticatedUser
                {
                    onPocketGoodsAppEvent(
                        .onToggleWishlist(
                            userId:
                                authenticatedUser
                                .id,
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
                                        severity:
                                            .success
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
                                                    .coreUIBundle,
                                                ""
                                            ),
                                        severity:
                                            .success
                                    )
                            }
                        )
                    )
                }
            },
            authenticatedUser: authState.authenticatedUser
        )
    }
}
