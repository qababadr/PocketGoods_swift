//
//  AuthenticationRobot.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-17.
//

import CoreApp
import CoreUI
import SwiftUI
import XCTest

final class AuthenticationRobot: Robot {

    func assertCanAuthenticate() {

        onButton(identifier: LocalKeys.toolbarLoginCd)
            .tap()

        let loginModalTitleElement = onUIElement(
            identifier: LocalKeys.login.localized(bundle: .coreUIBundle),
            accessibilityTrait: .isStaticText
        )

        XCTAssertTrue(loginModalTitleElement.waitForExistence(timeout: 5))

        insertText(identifier: LocalKeys.email, text: MockData.correctEmail)

        insertText(
            identifier: LocalKeys.password,
            text: MockData.correctPassword,
            textFieldType: .password
        )

        onKeyboardReturn()

        onButton(identifier: LocalKeys.loginButtonCd)
            .tap()

        loginModalTitleElement
            .waitForNonExistence(timeout: 5)

        let userMenuButton = onUIElement(
            identifier: LocalKeys.toolbarUserMenuCd,
            accessibilityTrait: .isButton
        )

        XCTAssertTrue(userMenuButton.waitForExistence(timeout: 5))
    }

    func assertCanRegister() {
        let name = "some user"
        let email = "email@email.email"
        let password = "Password123#"
        let confirmPassword = "Password123#"

        onButton(identifier: LocalKeys.toolbarLoginCd)
            .tap()

        onButton(identifier: LocalKeys.alreadyRegistered)
            .tap()

        onButton(identifier: LocalKeys.passwordVisibleToggleCd)
            .tap()

        onButton(identifier: LocalKeys.conformPasswordVisibleToggleCd)
            .tap()

        insertText(
            identifier: LocalKeys.fullName,
            text: name
        )

        insertText(
            identifier: LocalKeys.email,
            text: email
        )

        insertText(
            identifier: LocalKeys.password,
            text: password
        )

        insertText(
            identifier: LocalKeys.confirmPassword,
            text: confirmPassword
        )

        onKeyboardReturn()

        onButton(identifier: LocalKeys.registerButtonCd)
            .tap()

        waitAndAssertTextExist(
            identifier: LocalKeys
                .registered
                .localized(bundle: .coreUIBundle, name),
            timeout: 5
        )
    }

    func assertCanClickOnWishlistMenuItem() {
        onButton(identifier: LocalKeys.toolbarUserMenuCd)
            .tap()

        let wishlistMenuItem = onButton(
            identifier: LocalKeys.myWishlist
        )

        XCTAssertTrue(wishlistMenuItem.waitForExistence(timeout: 5))

        wishlistMenuItem.tap()
    }

    func assertCanClickOnLogoutMenuItem() {
        onButton(identifier: LocalKeys.toolbarUserMenuCd)
            .tap()

        let logoutMenuItem = onButton(identifier: LocalKeys.logout)

        XCTAssertTrue(logoutMenuItem.waitForExistence(timeout: 5))

        logoutMenuItem.tap()
    }

    func assertIsLoggedOut() {
        let userMenuButton = onUIElement(
            identifier: LocalKeys.toolbarUserMenuCd,
            accessibilityTrait: .isButton
        )

        XCTAssertTrue(userMenuButton.waitForNonExistence(timeout: 5))

        waitFor(0.5)

        XCTAssertTrue(
            onButton(identifier: LocalKeys.toolbarLoginCd)
                .exists
        )
    }

    func assertCanSwitchTheme() {
        var parentContainer = onUIElement(
            identifier: UIConstants.parentContainerInLightTheme,
            accessibilityTrait: .isStaticText
        )

        XCTAssertTrue(parentContainer.waitForExistence(timeout: 5))

        onButton(identifier: LocalKeys.toolbarUserMenuCd)
            .tap()

        let toggleWishlistMenu = onUIElement(
            identifier: LocalKeys.switchThemeUserMenuCd,
            accessibilityTrait: .isButton
        )

        XCTAssertTrue(toggleWishlistMenu.waitForExistence(timeout: 5))

        toggleWishlistMenu.tap()

        parentContainer = onUIElement(
            identifier: UIConstants.parentContainerInDarkTheme,
            accessibilityTrait: .isStaticText
        )

        XCTAssertTrue(parentContainer.waitForExistence(timeout: 5))
    }
}
