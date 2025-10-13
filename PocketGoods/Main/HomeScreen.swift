//
//  HomeScreen.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//

import AuthenticationFeature
import CoreApp
import CoreUI
import ProductFeature
import SwiftUI

struct HomeScreen: View {

    let productState: ProductState
    let onProductEvent: (ProductEvent) -> Void
    let onViewProduct: (Int64) -> Void
    let onToggleWishlist: (Int64, String) -> Void
    let authenticatedUser: User?

    var body: some View {
        VStack {
            HStack {
                Spacer()

                DiscountAnimation()
                    .frame(width: 100, height: 100)

                Spacer()
            }
            .padding()

            HStack {
                Spacer()

                Text(LocalKeys.lblDiscount.localized(bundle: .coreUIBundle))
                    .font(.displayMediumBold)
                    .foregroundColor(.theme().onSurface)

                Spacer()
            }
            .padding()

            ProductsFragment(
                state: productState,
                onEvent: onProductEvent,
                onViewProduct: onViewProduct,
                onToggleWishlist: onToggleWishlist,
                authenticatedUser: authenticatedUser
            )
            .padding(.top)
        }
        .background(Color.theme().background)
    }
}

private struct HomeScreenPreview: View {

    @State
    private var state: ProductState = ProductState()

    var body: some View {
        ScrollView {
            HomeScreen(
                productState: state,
                onProductEvent: { event in
                    switch event {

                    case .getProducts:
                        Task {
                            state = state.copy(isPageLoading: true)

                            try await Task.sleep(
                                nanoseconds: UIConstants.loadingInterval
                            )

                            state = state.copy(
                                products: MockData
                                    .productsPaginationResponse
                                    .data
                                    .map({ $0.toProductPreview() }),
                                isPageLoading: false
                            )
                        }
                    default:
                        break
                    }
                },
                onViewProduct: { _ in },
                onToggleWishlist: { _, _ in },
                authenticatedUser: MockData.userDTO.toUser()
            )
        }
    }
}

#Preview {
    HomeScreenPreview()
}
