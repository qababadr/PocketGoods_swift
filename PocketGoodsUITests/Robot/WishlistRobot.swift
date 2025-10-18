//
//  WishlistRobot.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-17.
//

import CoreApp
import CoreUI
import XCTest

final class WishlistRobot: Robot {

    func assertCanAddProductToWishlist() {
        let productToAdd = MockData
            .productsPaginationResponse
            .data[0]
            .toProductPreview()

        var toggleWishlistButton = onButton(
            identifier: LocalKeys
                .productNotInWishlistCd
                .localized(bundle: .coreUIBundle, productToAdd.title)
        )

        XCTAssertTrue(toggleWishlistButton.waitForExistence(timeout: 5))

        toggleWishlistButton.tap()

        toggleWishlistButton = onButton(
            identifier: LocalKeys
                .productInWishlistCd
                .localized(bundle: .coreUIBundle, productToAdd.title)
        )

        XCTAssertTrue(toggleWishlistButton.waitForExistence(timeout: 5))
    }

    func assertCanRemoveProductFromWishlist() {
        let productToRemove = MockData
            .productsPaginationResponse
            .data[0]
            .toProductPreview()

        let scrollable = onScrollable(
            identifier: UIConstants.scrollableContainer
        )

        if let thumbnail = productToRemove.thumbnail {

            let imageView = onUIElement(
                identifier: thumbnail,
                accessibilityTrait: .none
            ).firstMatch

            scrollable.scrollUntilExists(
                .up,
                target: imageView
            )

            imageView.tap()
        }

        var toggleWishlistButton = onButton(
            identifier: LocalKeys.productInWishlistCd.localized(
                bundle: .coreUIBundle,
                productToRemove.title
            )
        )

        XCTAssertTrue(toggleWishlistButton.waitForExistence(timeout: 5))

        toggleWishlistButton.tap()

        toggleWishlistButton = onUIElement(
            identifier: LocalKeys.productNotInWishlistCd.localized(
                bundle: .coreUIBundle,
                productToRemove.title
            ),
            accessibilityTrait: .isButton
        )

        XCTAssertTrue(toggleWishlistButton.waitForExistence(timeout: 5))
    }

    func assertCanDeleteProductFromAuthenticatedUserWishlist() {
        let productToRemove = MockData
            .productsPaginationResponse
            .data[0]
            .toProductPreview()

        let pageLoadingIndicator = onUIElement(
            identifier: UIConstants.loadingIndicator,
            accessibilityTrait: .none
        )

        XCTAssertTrue(pageLoadingIndicator.waitForNonExistence(timeout: 5))

        let scrollable = onScrollable(
            identifier: UIConstants.scrollableContainer
        )

        let openDeleteModal = onButton(
            identifier: LocalKeys
                .openDeleteModalCd
                .localized(
                    bundle: .coreUIBundle,
                    productToRemove.id.description
                )
        )

        scrollable.scrollUntilExists(
            .up,
            target: openDeleteModal
        )

        openDeleteModal.tap()

        waitAndAssertTextExist(
            identifier: LocalKeys
                .confirmation
                .localized(bundle: .coreUIBundle),
            timeout: 5
        )

        onButton(identifier: LocalKeys.removeFromWishlistCd)
            .tap()

        waitAndAssertTextDoesNotExist(
            identifier: productToRemove.title,
            timeout: 5
        )

        XCTAssertTrue(
            !onUIElement(
                identifier: LocalKeys.emptyWishlist.localized(
                    bundle: .coreUIBundle
                ),
                accessibilityTrait: .isStaticText
            ).exists
        )
    }
}
