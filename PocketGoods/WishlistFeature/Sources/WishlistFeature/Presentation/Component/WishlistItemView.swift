//
//  WishlistItemView.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-11.
//

import CoreApp
import CoreUI
import SwiftUI

struct WishlistItemView: View {

    let onProductClick: () -> Void
    let product: Product

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if let preview = product.media.first?.preview,
                let thumbnail = URL(string: preview)
            {
                NetworkImage(url: thumbnail)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.small))
            } else {
                Image(
                    "select-your-item-shopping-svgrepo-com",
                    bundle: .coreUIBundle
                )
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            }

            VStack(alignment: .leading, spacing: 4) {
                Button(action: onProductClick) {
                    Text(product.title)
                        .font(.titleMedium)
                        .bold()
                        .underline()
                        .foregroundColor(.theme().primary)
                }

                Text(
                    LocalKeys.priceValue.localized(
                        bundle: .coreUIBundle,
                        product.price.description
                    )
                )
                .font(.bodyMedium)
                .bold()
                .foregroundColor(.theme().onSurface)

                Text(
                    product.inStock
                        ? "\(product.quantity) \(LocalKeys.leftInStock.localized(bundle: .coreUIBundle))"
                        : LocalKeys.outOfStock.localized(bundle: .coreUIBundle)
                )
                .font(.bodyMedium)
                .foregroundColor(
                    product.inStock ? .theme().success : .theme().error
                )
            }
        }
    }
}

#Preview {
    WishlistItemView(
        onProductClick: {},
        product: MockData
            .sunGlassesProductResponse
            .data
    )
}
