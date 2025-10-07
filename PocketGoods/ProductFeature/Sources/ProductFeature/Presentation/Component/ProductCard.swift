//
//  ProductCard.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-07.
//

import CoreApp
import CoreUI
import SwiftUI

struct ProductCard: View {

    private let product: ProductPreview
    private let isAuthenticated: Bool
    private let inWishlist: Bool
    private let onViewProduct: (Int64) -> Void
    private let onToggleWishlist: (Int64, String) -> Void

    @State
    private var xOffset: CGFloat = 50

    init(
        product: ProductPreview,
        isAuthenticated: Bool,
        inWishlist: Bool,
        onViewProduct: @escaping (Int64) -> Void,
        onToggleWishlist: @escaping (Int64, String) -> Void
    ) {
        self.product = product
        self.isAuthenticated = isAuthenticated
        self.inWishlist = inWishlist
        self.onViewProduct = onViewProduct
        self.onToggleWishlist = onToggleWishlist
    }

    var body: some View {
        VStack {
            if let thumbnailString = product.thumbnail,
                let thumbnail = URL(string: thumbnailString)
            {

                ZStack(alignment: .topTrailing) {
                    NetworkImage(url: thumbnail)
                        .scaledToFit()
                        .onTapGesture {
                            if isAuthenticated {
                                withAnimation(.easeInOut) {
                                    xOffset = xOffset == 0 ? 50 : 0
                                }
                            }
                        }

                    if isAuthenticated {
                        LikeableIconButton(
                            isLiked: inWishlist,
                            onLikeClicked: {
                                onToggleWishlist(product.id, product.title)
                            },
                            iconSize: 26
                        )
                        .opacity(xOffset == 0 ? 1 : 0)
                        .padding(.all, 6)
                        .offset(x: xOffset)
                        .zIndex(80)
                        .accessibilityIdentifier(
                            inWishlist
                                ? LocalKeys.productInWishlistCd.localized(
                                    bundle: .coreUIBundle,
                                    product.title
                                )
                                : LocalKeys.productNotInWishlistCd.localized(
                                    bundle: .coreUIBundle,
                                    product.title
                                )
                        )
                    }
                }

            }

            Text(product.title)
                .font(.bodyLarge)
                .foregroundColor(.theme().onSurface)
                .bold()
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.vertical, 8)
                .accessibilityIdentifier(product.title)

            Text(
                LocalKeys.priceValue.localized(
                    bundle: .coreUIBundle,
                    product.price.description
                )
            )
            .font(.bodyMedium)
            .foregroundColor(.theme().onSurface)
            .bold()
            .accessibilityIdentifier(
                LocalKeys.productPriceCd.localized(
                    bundle: .coreUIBundle,
                    product.title
                )
            )
            .padding(.top, 8)
            .padding(.bottom, 16)

            Button(action: { onViewProduct(product.id) }) {
                Text(LocalKeys.learnMore.localized(bundle: .coreUIBundle))
                    .font(.bodyMedium)
                    .foregroundColor(.theme().onPrimary)
            }
            .accessibilityIdentifier(
                LocalKeys.learnMoreButtonCd.localized(
                    bundle: .coreUIBundle,
                    "\(product.id)"
                )
            )
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .background(Color.theme().primary)
            .clipShape(RoundedRectangle(cornerRadius: Theme.small))
            .padding(.bottom, 26)
        }
        .background(Color.theme().surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.medium))
        .shadow(radius: Theme.medium)
    }
}

private struct ProductCardPreview: View {
    
    @State
    private var inWishlist: Bool = false
    
    let product = MockData
        .productsPaginationResponse
        .data[0]
        .toProductPreview()
    
    
    var body: some View {
        VStack {
            ProductCard(
                product: product,
                isAuthenticated: true,
                inWishlist: inWishlist,
                onViewProduct: { _ in },
                onToggleWishlist: { _, _ in
                    inWishlist.toggle()
                }
            )
        }
    }
}

#Preview {
    ProductCardPreview()
}
