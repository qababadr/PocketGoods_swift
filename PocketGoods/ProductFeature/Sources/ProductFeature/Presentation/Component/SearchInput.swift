//
//  SearchInput.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-07.
//

import CoreApp
import CoreUI
import SwiftUI

public struct SearchInput: View {

    @Binding
    private var query: String

    private let searchLabel: String
    private let onSearch: (String) -> Void
    private let search: () -> Void
    private let clearQuery: () -> Void
    private let onSuggestedProductClick: (Int64) -> Void
    private let isProcessing: Bool
    private let suggestedProducts: [ProductPreview]
    private let textFieldWidth: CGFloat
    private let autoCompleteWidth: CGFloat
    private let autoCompleteHeight: CGFloat

    @State
    private var isExpanded: Bool = false

    @State
    private var isFocused: Bool = false

    @State
    private var textFieldSize: CGFloat = 0

    public init(
        query: Binding<String>,
        searchLabel: String,
        onSearch: @escaping (String) -> Void = { _ in },
        search: @escaping () -> Void,
        clearQuery: @escaping () -> Void,
        onSuggestedProductClick: @escaping (Int64) -> Void,
        suggestedProducts: [ProductPreview],
        isProcessing: Bool = false,
        textFieldWidth: CGFloat = 300,
        autoCompleteWidth: CGFloat = 300,
        autoCompleteHeight: CGFloat = 300
    ) {
        _query = query
        self.searchLabel = searchLabel
        self.onSearch = onSearch
        self.search = search
        self.clearQuery = clearQuery
        self.onSuggestedProductClick = onSuggestedProductClick
        self.isProcessing = isProcessing
        self.suggestedProducts = suggestedProducts
        self.textFieldWidth = textFieldWidth
        self.autoCompleteWidth = autoCompleteWidth
        self.autoCompleteHeight = autoCompleteHeight
    }

    public var body: some View {
        ZStack(alignment: .top) {
            TextInput(
                value: $query,
                label: searchLabel,
                onChange: { newValue in
                    withAnimation(.easeInOut) {
                        if !isExpanded {
                            isExpanded = !newValue.isEmpty
                        }
                    }
                    onSearch(newValue)
                },
                onFocusedChange: { isFocused in
                    withAnimation(.easeInOut) {
                        self.isFocused = isFocused
                    }
                },
                accessibilityIdentifier: LocalKeys.searchProductsCd
                    .localized(bundle: .coreUIBundle),
                trailingIconAI: LocalKeys.searchInputSearchButtonCd,
                leadingIconName: "magnify",
                clearable: true,
                isProcessing: isProcessing,
                iconsColor: .theme().secondary,
                onTrailingIconClick: {
                    withAnimation(.easeInOut) {
                        isExpanded.toggle()
                    }
                    search()
                },
                onClearClick: clearQuery,
                borderColor: .theme().background,
                cornerRadius: 25,
            )
            .frame(
                width: isFocused
                    ? textFieldWidth + (textFieldWidth * 0.3) : textFieldWidth,
                alignment: .leading
            )
            .animation(.easeInOut, value: isFocused)
            .zIndex(20)

            if isExpanded && !suggestedProducts.isEmpty && !query.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(suggestedProducts, id: \.id) { product in
                            SearchSuggestionItem(
                                thumbnail: product.thumbnail,
                                title: product.title,
                                category: product.category,
                                onClick: {
                                    withAnimation(.easeInOut) {
                                        isExpanded.toggle()
                                    }
                                    onSuggestedProductClick(product.id)
                                }
                            )
                            .accessibilityIdentifier(
                                LocalKeys
                                    .suggestedProductCd
                                    .localized(
                                        bundle: .coreUIBundle,
                                        product.id.description
                                    )
                            )
                        }
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .accessibilityIdentifier(
                    LocalKeys.searchInputListTestTagCd
                )
                .zIndex(10)
                .padding(.top, 6)
                .frame(
                    width: autoCompleteWidth,
                    height: autoCompleteHeight
                )
                .background(Color.theme().surface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.small))
                .padding(.top, 65)
                .padding(.leading, 20)
            }
        }
    }
}

private struct SearchInputPreview: View {

    @State
    private var query: String = ""

    @State
    private var suggestions: [ProductPreview] = []

    @State
    private var isProcessing: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                SearchInput(
                    query: $query,
                    searchLabel: "Search",
                    onSearch: { query in
                        isProcessing.toggle()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            suggestions = MockData.suggestedProducts(
                                query: query
                            )
                            .data
                            .map({ $0.toProductPreview() })
                            
                            
                            isProcessing.toggle()
                        }
                    },
                    search: {},
                    clearQuery: {
                        query = ""
                        suggestions = []
                    },
                    onSuggestedProductClick: { id in
                        query = id.description
                    },
                    suggestedProducts: suggestions
                )
                .background(Color.theme().surface)
                .onAppear {
                    suggestions =
                        MockData
                        .suggestedProducts(query: "")
                        .data
                        .map({ $0.toProductPreview() })
                }
            }
        }
    }
}

#Preview {
    SearchInputPreview()
}
