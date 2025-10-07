//
//  ToggleWishlistButton.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-07.
//

import CoreUI
import SwiftUI

struct ToggleWishlistButton: View {

    private let onToggleWishlist: () -> Void
    private let inWishlist: Bool

    init(onToggleWishlist: @escaping () -> Void, inWishlist: Bool) {
        self.onToggleWishlist = onToggleWishlist
        self.inWishlist = inWishlist
    }

    var body: some View {
        Button(action: onToggleWishlist) {
            HStack(alignment: .center, spacing: 6) {
                Image(
                    inWishlist ? "heart-minus" : "heart-plus",
                    bundle: .coreUIBundle
                )
                .resizable()
                .scaledToFit()
                .accessibilityIdentifier(
                    inWishlist
                        ? LocalKeys.removeFromWishlistCd
                        : LocalKeys.addToWishlistCd
                )
                .frame(width: 26, height: 26)
                .foregroundColor(.theme().onPrimary)
                .animation(nil, value: inWishlist)

                Text(
                    (inWishlist
                        ? LocalKeys
                            .removeFromWishlistLabel
                            .localized(bundle: .coreUIBundle)
                        : LocalKeys
                            .addToWishlistLabel
                            .localized(bundle: .coreUIBundle))
                )
                .font(.titleSmall)
                .foregroundColor(.theme().onPrimary)
                .animation(nil, value: inWishlist)
            }
        }
        .accessibilityIdentifier(UIConstants.toggleWishlistButton)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
    }
}

private struct ToggleWishlistButtonPreview: View {

    @State
    private var inWishlist: Bool = false

    var body: some View {
        ToggleWishlistButton(
            onToggleWishlist: { inWishlist.toggle() },
            inWishlist: inWishlist
        )
        .frame(width: 230)
        .background(Color.theme().primary)
        .clipShape(RoundedRectangle(cornerRadius: Theme.medium))
    }
}

#Preview {
    ToggleWishlistButtonPreview()
}
