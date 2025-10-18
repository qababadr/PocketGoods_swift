//
//  ProductRobot.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-14.
//
import CoreApp
import CoreUI
import XCTest

final class ProductRobot: Robot {

    func assertHasLisOfProducts() {
        MockData
            .productsPaginationResponse
            .data
            .map { $0.toProductPreview() }
            .forEach { product in
                scrollAndAssertHasCorrectData(product: product)
            }
    }

    func assertCanNavigateToProductFromList() {
        let product = MockData
            .sunGlassesProductResponse
            .data

        if let thumbnail = product.media.first?.preview {

            onScrollable(identifier: UIConstants.scrollableContainer)
                .scrollUntilExists(
                    .up,
                    target: onUIElement(
                        identifier: thumbnail,
                        accessibilityTrait: .none
                    ).firstMatch
                )
        }

        onUIElement(
            identifier: LocalKeys.learnMoreButtonCd.localized(
                bundle: .coreUIBundle,
                "\(product.id)"
            ),
            accessibilityTrait: .isButton
        )
        .tap()

        waitAndAssertTextExist(
            identifier: product.title,
            timeout: UIConstants.endToEndTimeout
        )
    }

    func assertIsPageReady() {
        onProgressIndicator(
            identifier: UIConstants.loadingIndicator
        ).waitForNonExistence(timeout: UIConstants.endToEndTimeout)
    }

    func assertHasCorrectDetail(
        product: Product = MockData.sunGlassesProductResponse.data
    ) {
        for (index, image) in product.media.enumerated() {
            let exists = onUIElement(
                identifier: image.original,
                accessibilityTrait: .none
            ).waitForExistence(timeout: 2)

            XCTAssertTrue(
                exists,
                "Image at index \(index) with id \(image.original) not found"
            )
        }

        assertHasText(text: product.title)

        onScrollable(identifier: UIConstants.scrollableContainer)
            .swipeUp()

        assertHasText(
            text: LocalKeys.price.localized(
                bundle: .coreUIBundle
            ) + " "
                + LocalKeys.priceValue.localized(
                    bundle: .coreUIBundle,
                    product.price.formatted()
                )
        )

        assertHasText(
            text: LocalKeys.description.localized(
                bundle: .coreUIBundle
            ),
        )

        assertHasText(text: product.description)

        assertHasText(
            text: "\(product.quantity) "
                + (product.inStock
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
                        ))
        )

        assertHasText(
            text: product.category
        )

        assertHasImage(identifier: LocalKeys.addToWishlistCd)
    }

    func assertCanShowProductSuggestions() {
        let searchQuery = "s"
        let correctSuggestedProducts = MockData.suggestedProducts(
            query: searchQuery
        )

        insertText(
            identifier: LocalKeys.searchProductsCd.localized(
                bundle: .coreUIBundle
            ),
            text: searchQuery
        )

        waitFor(1)

        let scrollable = onScrollable(
            identifier: LocalKeys.searchInputListTestTagCd
        )

        correctSuggestedProducts.data.forEach { product in
            scrollable.scrollUntilExists(
                .up,
                target: onUIElement(
                    identifier: product.title,
                    accessibilityTrait: .isStaticText
                ).firstMatch
            )

            scrollable.scrollUntilExists(
                .up,
                target: onUIElement(
                    identifier: product.category,
                    accessibilityTrait: .isStaticText
                ).firstMatch
            )

            let _ = onUIElement(
                identifier: LocalKeys
                    .suggestedProductCd
                    .localized(bundle: .coreUIBundle, "image_\(product.title)"),
                accessibilityTrait: .none
            ).waitForExistence(timeout: 5)
        }
    }

    func assertCanNavigateToProductDetailFromSuggestedProducts() {
        let searchQuery = "s"
        let product = MockData.sunGlassesProductResponse.data

        insertText(
            identifier: LocalKeys.searchProductsCd
                .localized(bundle: .coreUIBundle),
            text: searchQuery
        )
        
        waitFor(1)

        let scrollable = onScrollable(
            identifier: LocalKeys.searchInputListTestTagCd
        )

        scrollable.scrollUntilExists(
            .down,
            target: onUIElement(
                identifier: LocalKeys
                    .suggestedProductCd
                    .localized(
                        bundle: .coreUIBundle,
                        product.id.description
                    ),
                accessibilityTrait: .none
            ).firstMatch
        )

        let suggestedProductElement = onUIElement(
            identifier: LocalKeys
                .suggestedProductCd
                .localized(
                    bundle: .coreUIBundle,
                    product.id.description
                ),
            accessibilityTrait: .none
        )

        suggestedProductElement.tap()

        onKeyboardReturn()
        
        waitFor(1)

        assertHasCorrectDetail(product: product)
    }

    func assertHasMatchingProducts(searchQuery: String) {
        let correctSuggestedProducts = MockData.suggestedProducts(
            query: searchQuery
        )

        correctSuggestedProducts
            .data
            .map { $0.toProductPreview() }
            .forEach { product in
                scrollAndAssertHasCorrectData(product: product)
            }
    }

    func assertCanNavigateToSearchResultScreen(searchQuery: String) {
        insertText(
            identifier: LocalKeys.searchProductsCd
                .localized(bundle: .coreUIBundle),
            text: searchQuery
        )

        onKeyboardReturn()

        let searchLoadingIndicator = onUIElement(
            identifier: LocalKeys.searchInputLoadingIndicatorCd,
            accessibilityTrait: .none
        )

        searchLoadingIndicator.waitForNonExistence(timeout: 2)

        onButton(identifier: LocalKeys.searchInputSearchButtonCd)
            .tap()

        waitFor(1)
    }

    func assertHasWarningMessage() {
        waitAndAssertTextExist(
            identifier: LocalKeys.emptyProductList.localized(
                bundle: .coreUIBundle
            ),
            timeout: 5
        )
    }

    private func scrollAndAssertHasCorrectData(product: ProductPreview) {
        if let thumbnail = product.thumbnail {
            onScrollable(identifier: UIConstants.scrollableContainer)
                .scrollUntilExists(
                    .up,
                    target: onUIElement(
                        identifier: thumbnail,
                        accessibilityTrait: .none
                    )
                )
        }

        assertHasText(text: product.title)

        assertHasText(
            text: LocalKeys.priceValue.localized(
                bundle: .coreUIBundle,
                product.price.description
            )
        )

        assertHasButton(
            identifier: LocalKeys.learnMoreButtonCd.localized(
                bundle: .coreUIBundle,
                "\(product.id)"
            )
        )
    }
}
