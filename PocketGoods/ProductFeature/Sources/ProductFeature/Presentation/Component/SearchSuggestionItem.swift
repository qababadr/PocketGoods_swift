//
//  SearchSuggestionItem.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-07.
//

import CoreApp
import CoreUI
import SwiftUI

struct SearchSuggestionItem: View {

    private let thumbnail: String?
    private let title: String
    private let category: String
    private let onClick: () -> Void

    init(
        thumbnail: String?,
        title: String,
        category: String,
        onClick: @escaping () -> Void
    ) {
        self.thumbnail = thumbnail
        self.title = title
        self.category = category
        self.onClick = onClick
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if let thumbnailString = thumbnail,
                let thumbnail = URL(string: thumbnailString)
            {
                NetworkImage(
                    url: thumbnail,
                    accessibilityIdentifier: LocalKeys
                        .suggestedProductCd
                        .localized(bundle: .coreUIBundle, "image_\(title)")
                )
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
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
                Text(title)
                    .font(.labelMedium)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.theme().primary)
                    .accessibilityIdentifier(
                        LocalKeys
                            .suggestedProductCd
                            .localized(bundle: .coreUIBundle, title)
                    )

                Text(category)
                    .font(.labelSmall)
                    .bold()
                    .foregroundColor(.theme().onSurface)
                    .accessibilityIdentifier(
                        LocalKeys
                            .suggestedProductCd
                            .localized(bundle: .coreUIBundle, category)
                    )
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onClick()
        }
    }
}

#Preview {
    let suggestion = MockData
        .productsPaginationResponse
        .data[0]
        .toProductPreview()
    
    SearchSuggestionItem(
        thumbnail: suggestion.thumbnail,
        title: suggestion.title,
        category: suggestion.category,
        onClick: {}
    )
}
