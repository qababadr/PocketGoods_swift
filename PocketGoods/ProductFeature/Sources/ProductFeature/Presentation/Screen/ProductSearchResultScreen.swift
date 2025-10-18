//
//  ProductSearchResultScreen.swift
//  ProductFeature
//
//  Created by BADR QABA on 2025-10-07.
//

import CoreApp
import CoreUI
import SwiftUI

public struct ProductSearchResultScreen: View {

    private let state: ProductState
    private let onEvent: (ProductEvent) -> Void
    private let onViewProduct: (Int64) -> Void
    private let onToggleWishlist: (Int64, String) -> Void
    private let authenticatedUser: User?

    public init(
        state: ProductState,
        onEvent: @escaping (ProductEvent) -> Void,
        onViewProduct: @escaping (Int64) -> Void,
        onToggleWishlist: @escaping (Int64, String) -> Void,
        authenticatedUser: User? = nil
    ) {
        self.state = state
        self.onEvent = onEvent
        self.onViewProduct = onViewProduct
        self.onToggleWishlist = onToggleWishlist
        self.authenticatedUser = authenticatedUser
    }

    public var body: some View {
        ZStack {
            if state.isPageLoading && state.searchResult.isEmpty {
                ProgressView()
                    .tint(.theme().primary)
                    .accessibilityIdentifier(UIConstants.loadingIndicator)
                    .padding()
            } else {
                switch true {
                case state.error != nil:
                    WarningMessage(
                        text: LocalKeys.errorFetchingData.localized(
                            bundle: .coreUIBundle
                        ),
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
                    
                    AnimatableDelayable(
                        condition: state.searchResult.isEmpty,
                        deadline: .now() + 1
                    ) {
                        WarningMessage(
                            text: LocalKeys
                                .emptyProductList
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
                    }
                    
                    if !state.searchResult.isEmpty {
                        
                        LazyVGrid(
                            columns: [
                                GridItem(
                                    .adaptive(
                                        minimum: UIScreen.main.bounds.width
                                        / UIScreen.main.bounds.size
                                            .getScreenSize()
                                            .getGridLayoutColumns()
                                    )
                                )
                            ]
                        ) {
                            ForEach(state.searchResult, id: \.id) { product in
                                ProductCard(
                                    product: product,
                                    isAuthenticated: authenticatedUser != nil,
                                    inWishlist: authenticatedUser?.inWishlist(
                                        productId: product.id
                                    ) ?? false,
                                    onViewProduct: onViewProduct,
                                    onToggleWishlist: onToggleWishlist
                                )
                                .padding(10)
                                .onAppear {
                                    if product.id == state.searchResult.last?.id
                                        && !state.isPageLoading
                                    {
                                        onEvent(.onNextPage)
                                        onEvent(.searchProducts)
                                    }
                                }
                            }
                            
                            if state.isPageLoading {
                                ProgressView()
                                    .tint(.theme().primary)
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: .infinity,
                                        alignment: .center
                                    )
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onEvent(.searchProducts)
            }
        }
    }
}

private struct ProductSearchResultScreenPreview: View {

    @State private var state: ProductState = ProductState()

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ProductSearchResultScreen(
                state: state,
                onEvent: { event in
                    switch event {
                    case .searchProducts:
                        Task {
                            state = state.copy(isPageLoading: true)
                            try await Task.sleep(
                                nanoseconds: UIConstants.loadingInterval
                            )
                            state = state.copy(
                                searchResult: MockData.searchPaginationResponse(
                                    query: "s"
                                )
                                .data
                                .map { $0.toProductPreview() },
                                isPageLoading: false
                            )
                        }

                    case .onNextPage:
                        state = state.copy(currentPage: 2)

                    default:
                        break
                    }
                },
                onViewProduct: { _ in },
                onToggleWishlist: { _, _ in }
            )
        }
    }
}

#Preview {
    ProductSearchResultScreenPreview()
}
