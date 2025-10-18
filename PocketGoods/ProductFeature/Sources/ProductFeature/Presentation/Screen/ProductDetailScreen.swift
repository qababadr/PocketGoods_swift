//
//  ProductDetailScreen.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-07.
//

import CoreApp
import CoreUI
import SwiftUI

public struct ProductDetailScreen: View {

    private let state: ProductState
    private let onToggleWishlist: (Int64, String) -> Void
    private let onEvent: (ProductEvent) -> Void
    private let authenticatedUser: User?
    private let productId: Int64

    public init(
        state: ProductState,
        productId: Int64,
        onToggleWishlist: @escaping (Int64, String) -> Void,
        onEvent: @escaping (ProductEvent) -> Void,
        authenticatedUser: User? = nil
    ) {
        self.state = state
        self.productId = productId
        self.onToggleWishlist = onToggleWishlist
        self.onEvent = onEvent
        self.authenticatedUser = authenticatedUser
    }

    public var body: some View {
        ZStack {
            if state.isPageLoading {
                ProgressView()
                    .tint(.theme().primary)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                    .padding()
                    .accessibilityIdentifier(UIConstants.loadingIndicator)

            } else {
                switch true {
                case state.error != nil:
                    WarningMessage(
                        text: LocalKeys
                            .errorFetchingData
                            .localized(bundle: .coreUIBundle),
                        iconName: "information"
                    )
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.theme().warning)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.medium))
                    .padding()
                    .shadow(radius: Theme.medium)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )

                default:
                    VStack(alignment: .leading, spacing: 20) {
                        if let product = state.product {
                            NetworkCarousel(
                                urls: product.originalImages(),
                                isAutoPlay: true
                            )
                            .frame(height: 500)

                            Text(product.title)
                                .font(.labelLarge)
                                .foregroundColor(.theme().primary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .padding(.horizontal, 12)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .center
                                )

                            (Text(
                                LocalKeys.price.localized(bundle: .coreUIBundle)
                                    + " "
                            )
                            .bold()
                            .foregroundColor(.theme().primary)
                                + Text(
                                    LocalKeys.priceValue.localized(
                                        bundle: .coreUIBundle,
                                        product.price.formatted()
                                    )
                                )
                                .foregroundColor(.theme().onBackground))
                                .font(.bodyMedium)
                                .padding(.leading, 8)
                                .accessibilityElement(children: .combine)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(
                                    LocalKeys.description.localized(
                                        bundle: .coreUIBundle
                                    )
                                )
                                .font(.bodyMedium)
                                .bold()
                                .foregroundColor(.theme().primary)
                                .accessibilityIdentifier(
                                    LocalKeys.description.localized(
                                        bundle: .coreUIBundle
                                    )
                                )

                                Text(product.description)
                                    .font(.bodyMedium)
                                    .foregroundColor(.theme().onBackground)

                                (Text("\(product.quantity) ")
                                    .bold()
                                    .foregroundColor(
                                        product.inStock
                                            ? .theme().success
                                            : .theme().error
                                    )
                                    + Text(
                                        product.inStock
                                            ? LocalKeys.leftInStock
                                                .localized(
                                                    bundle: .coreUIBundle,
                                                    String(
                                                        describing: product
                                                            .quantity
                                                    )
                                                )
                                            : LocalKeys.outOfStock
                                                .localized(
                                                    bundle: .coreUIBundle
                                                )
                                    ).foregroundColor(.theme().onBackground))
                                    .font(.bodyMedium)
                                    .accessibilityElement(children: .combine)
                            }
                            .padding(.leading, 8)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(
                                    LocalKeys.category.localized(
                                        bundle: .coreUIBundle
                                    )
                                )
                                .font(.bodyMedium)
                                .bold()
                                .foregroundColor(.theme().primary)

                                Text(product.category)
                                    .font(.bodyMedium)
                                    .foregroundColor(.theme().onBackground)

                                HStack {
                                    Spacer()

                                    ToggleWishlistButton(
                                        onToggleWishlist: {
                                            onToggleWishlist(
                                                product.id,
                                                product.title
                                            )
                                        },
                                        inWishlist: inWishlist
                                    )
                                    .frame(width: inWishlist ? 250 : 200)
                                    .background(Color.theme().primary)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: Theme.medium
                                        )
                                    )

                                    Spacer()
                                }
                                .padding(.top, 18)
                                .padding(.bottom, 20)
                            }
                            .padding(.leading, 8)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .background(Color.theme().background)
        .onAppear {
            onEvent(.loadProduct(productId))
        }
    }
}

extension ProductDetailScreen {
    private var inWishlist: Bool {
        authenticatedUser?
            .inWishlist(productId: productId) ?? false
    }
}

private struct ProductDetailScreenPreview: View {

    @State
    private var state = ProductState()

    private let mockProduct = MockData
        .sunGlassesProductResponse
        .data

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                ProductDetailScreen(
                    state: state,
                    productId: mockProduct.id,
                    onToggleWishlist: { _, _ in },
                    onEvent: { event in
                        switch event {
                            
                        case .loadProduct(mockProduct.id):
                            Task {
                                state = state.copy(isPageLoading: true)
                                
                                try? await Task.sleep(
                                    nanoseconds: UIConstants.loadingInterval
                                )
                                
                                state = state.copy(
                                    isPageLoading: false,
                                    product: mockProduct
                                )
                            }
                            break
                            
                        default:
                            break
                        }
                    },
                    authenticatedUser: nil
                )
                .frame(minHeight: geometry.size.height)
            }
        }
    }
}

#Preview {
    ProductDetailScreenPreview()
}
