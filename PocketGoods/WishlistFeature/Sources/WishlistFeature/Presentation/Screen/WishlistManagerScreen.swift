//
//  WishlistManagerScreen.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-11.
//

import CoreApp
import CoreUI
import SwiftUI

public struct WishlistManagerScreen: View {

    @Binding
    public var state: WishlistManagerState

    public let onEvent: (WishlistManagerScreenEvent) -> Void
    public let onDeleteSuccess: (String) -> Void
    public let onDeleteError: (String) -> Void
    public let onProductClick: (Int64) -> Void
    public let authenticatedUser: User?

    @EnvironmentObject
    private var modalController: ModalController

    @State
    private var shouldShowEmptyMessage = false

    public init(
        state: Binding<WishlistManagerState>,
        onEvent: @escaping (WishlistManagerScreenEvent) -> Void,
        onDeleteSuccess: @escaping (String) -> Void,
        onDeleteError: @escaping (String) -> Void,
        onProductClick: @escaping (Int64) -> Void,
        authenticatedUser: User?
    ) {
        _state = state
        self.onEvent = onEvent
        self.onDeleteSuccess = onDeleteSuccess
        self.onDeleteError = onDeleteError
        self.onProductClick = onProductClick
        self.authenticatedUser = authenticatedUser
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if state.isPageLoading {
                ProgressView()
                    .tint(.theme().primary)
                    .accessibilityIdentifier(UIConstants.loadingIndicator)
                    .padding()
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

                default:
                    VStack {
                        Text(
                            LocalKeys.myWishlist.localized(
                                bundle: .coreUIBundle
                            )
                        )
                        .font(.displaySmall)
                        .foregroundColor(.theme().onBackground)
                        .underline()
                        .padding(.vertical, 26)
                        .frame(maxWidth: .infinity, alignment: .center)

                        VStack {
                            if shouldShowEmptyMessage {
                                WarningMessage(
                                    text: LocalKeys.emptyWishlist.localized(
                                        bundle: .coreUIBundle
                                    ),
                                    iconName: "information"
                                )
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.theme().warning)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: Theme.medium)
                                )
                                .padding()
                                .shadow(radius: Theme.medium)
                                .transition(.scale.combined(with: .opacity))
                                .animation(
                                    .interpolatingSpring(
                                        stiffness: 200,
                                        damping: 22
                                    ),
                                    value: shouldShowEmptyMessage
                                )
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 1
                            ) {
                                if state.wishlist.isEmpty {
                                    withAnimation {
                                        shouldShowEmptyMessage = true
                                    }
                                }
                            }
                        }
                        .onChange(of: state.wishlist) { newWishlist in
                            if newWishlist.isEmpty {
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 1
                                ) {
                                    withAnimation {
                                        shouldShowEmptyMessage = true
                                    }
                                }
                            } else {
                                withAnimation {
                                    shouldShowEmptyMessage = false
                                }
                            }
                        }

                        if !state.wishlist.isEmpty {

                            ForEach(state.wishlist, id: \.id) { item in
                                if let product = item.productDetail {
                                    HStack(alignment: .top) {
                                        WishlistItemView(
                                            onProductClick: {
                                                onProductClick(product.id)
                                            },
                                            product: product
                                        )

                                        Spacer()

                                        WishlistItemDeleteButton(
                                            product: product,
                                            state: $state,
                                            onDelete: {
                                                if let authenticatedUser {
                                                    onEvent(
                                                        .deleteWishlistItem(
                                                            userId:
                                                                authenticatedUser
                                                                .id,
                                                            productId:
                                                                product.id,
                                                            onSuccess: {
                                                                onDeleteSuccess(
                                                                    product
                                                                        .title
                                                                )
                                                                onEvent(
                                                                    .getWishlistItems(
                                                                        userId:
                                                                            authenticatedUser
                                                                            .id
                                                                    )
                                                                )
                                                            },
                                                            onError: { _ in
                                                                onDeleteError(
                                                                    product
                                                                        .title
                                                                )
                                                            }
                                                        )
                                                    )
                                                }
                                            }
                                        )
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if let authenticatedUser {
                onEvent(.getWishlistItems(userId: authenticatedUser.id))
            }
        }
    }
}

private struct WishlistManagerScreenPreview: View {

    @State
    private var state = WishlistManagerState()

    @StateObject
    private var modalController = ModalController()

    var body: some View {
        WishlistManagerScreen(
            state: $state,
            onEvent: { event in
                switch event {
                case .getWishlistItems(_):
                    state = state.copy(isPageLoading: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        state = state.copy(
                            isPageLoading: false,
                            wishlist: MockData.userDTO.wishlist.map {
                                $0.toWishlistItem()
                            }
                        )
                    }

                case .deleteWishlistItem(_, let productId, _, _):
                    state = state.copy(isDeleting: true)
                    let newWishlist = state.wishlist.filter {
                        $0.productId != productId
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        modalController.dismiss()
                        state = state.copy(
                            isDeleting: false,
                            wishlist: newWishlist
                        )
                    }
                }
            },
            onDeleteSuccess: { _ in },
            onDeleteError: { _ in },
            onProductClick: { _ in },
            authenticatedUser: MockData.userDTO.toUser()
        )
        .modalHost()
        .environmentObject(modalController)
    }
}

#Preview {
    LatoFont.registerFonts()
    return WishlistManagerScreenPreview()
}
