//
//  WishlistConfirmDialogContent.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-11.
//

import CoreUI
import SwiftUI

struct WishlistConfirmDialogContent: View {

    @Binding
    private var isDeleting: Bool

    private let productTitle: String
    private let closeDeleteConfirmationModal: () -> Void
    private let onDelete: () -> Void

    init(
        isDeleting: Binding<Bool>,
        productTitle: String,
        closeDeleteConfirmationModal: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.closeDeleteConfirmationModal = closeDeleteConfirmationModal
        self.onDelete = onDelete
        self.productTitle = productTitle
        _isDeleting = isDeleting
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(
                LocalKeys.confirmation.localized(bundle: .coreUIBundle)
            )
            .foregroundColor(.theme().onPrimary)
            .font(.headlineSmall)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(Color.theme().warning)
            .padding(.bottom)

            (Text(
                LocalKeys.wishlistDeletionPart1.localized(
                    bundle: .coreUIBundle
                )
            ).font(.bodyMedium)
             + Text(" \(productTitle) ").font(.bodyMediumBold)
                + Text(
                    LocalKeys.wishlistDeletionPart2.localized(
                        bundle: .coreUIBundle
                    )
                ).font(.bodyMedium))
                .foregroundColor(.theme().onBackground)
                .padding()

            Divider().padding(.vertical)

            HStack(alignment: .center, spacing: 10) {
                Spacer()

                Button(action: closeDeleteConfirmationModal) {
                    Text(
                        LocalKeys.close.localized(
                            bundle: .coreUIBundle
                        )
                    )
                    .font(.bodyMedium)
                    .foregroundColor(.theme().onPrimary)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.theme().secondary)
                .shadow(radius: Theme.small)

                ProgressButton(
                    isLoading: isDeleting,
                    action: onDelete,
                    backgroundColor: .theme().primary,
                    width: 100,
                    accessibilityIdentifier: LocalKeys
                        .removeFromWishlistCd
                ) {
                    Text(
                        LocalKeys.delete.localized(
                            bundle: .coreUIBundle
                        )
                    )
                    .font(.bodyMedium)
                    .foregroundColor(.theme().onPrimary)
                }
                .shadow(radius: Theme.small)
                .padding(.trailing, 8)
            }
            .padding()
        }
        .background(Color.theme().background)
    }
}
