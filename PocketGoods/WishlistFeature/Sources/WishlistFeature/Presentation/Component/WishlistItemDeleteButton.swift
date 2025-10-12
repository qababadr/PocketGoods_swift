//
//  WishlistItemDeleteButton.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-11.
//

import CoreApp
import CoreUI
import SwiftUI

struct WishlistItemDeleteButton: View {

    let product: Product
    
    @Binding
    var state: WishlistManagerState

    @EnvironmentObject
    private var modalController: ModalController

    let onDelete: () -> Void
    
    @State
    private var isDeleting = false
    
    var body: some View {
        Button(action: {
            modalController.show {
                WishlistConfirmDialogContent(
                    isDeleting: $isDeleting,
                    productTitle: product.title,
                    closeDeleteConfirmationModal: {
                        modalController.dismiss()
                    },
                    onDelete: onDelete
                )
            }
        }) {
            Image("delete", bundle: .coreUIBundle)
                .resizable()
                .scaledToFit()
                .frame(width: 26)
        }
        .buttonStyle(.borderedProminent)
        .clipShape(Circle())
        .tint(.theme().error)
        .accessibilityIdentifier(
            LocalKeys
                .openDeleteModalCd
                .localized(bundle: .coreUIBundle, product.id.description)
        )
        .onChange(of: state.isDeleting) { isDeleting in
            self.isDeleting = isDeleting
        }
    }
}
