//
//  Robot.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//
import Foundation
import SwiftUICore
import XCTest

public enum SwipeDirection {
    case up, down, right, left

    private var leftPoint: CGVector { CGVector(dx: 0.05, dy: 0.5) }
    private var rightPoint: CGVector { CGVector(dx: 0.95, dy: 0.5) }
    private var topPoint: CGVector { CGVector(dx: 0.5, dy: 0.05) }
    private var bottomPoint: CGVector { CGVector(dx: 0.5, dy: 0.95) }

    var vector: (begin: CGVector, end: CGVector) {
        switch self {
        case .up:
            return (begin: bottomPoint, end: topPoint)

        case .down:
            return (begin: topPoint, end: bottomPoint)

        case .left:
            return (begin: rightPoint, end: leftPoint)

        case .right:
            return (begin: leftPoint, end: rightPoint)
        }
    }
}

extension XCUIElement {
    
    @discardableResult
    func scrollUntilExists(
        _ direction: SwipeDirection,
        target element: XCUIElement,
        swipeLimit: Int = 6,
        swipeDuration: TimeInterval = 0.3,
        waitBetweenSwipes: TimeInterval = 0.3,
    ) -> Bool {
        XCTAssert(exists, "Scrollable element must exist before swiping.")

        let start = coordinate(withNormalizedOffset: direction.vector.begin)
        let end = coordinate(withNormalizedOffset: direction.vector.end)

        var remaining = swipeLimit

        while !element.exists && remaining > 0 {
            start.press(forDuration: swipeDuration, thenDragTo: end)

            RunLoop.current.run(
                until: Date().addingTimeInterval(waitBetweenSwipes)
            )

            remaining -= 1
        }

        return element.exists
    }
}

public enum TextFieldType {
    case normal, password
}

extension AccessibilityTraits {
    public static var none: AccessibilityTraits {
        AccessibilityTraits()
    }
}

public class Robot {

    private let app: XCUIApplication

    public init(app: XCUIApplication) {
        self.app = app
    }

    public func getApp() -> XCUIApplication {
        return app
    }

    func assertHasImage(identifier: String) {
        let image = app.images[identifier]
        XCTAssertTrue(
            image.exists,
            "Image with accessibility identifier \(identifier) does not exist"
        )
    }

    func assertHasButton(identifier: String) {
        let button = app.buttons[identifier]
        XCTAssertTrue(
            button.exists,
            "Button with accessibility identifier \(identifier) does not exist"
        )
    }

    func waitAndAssertImageDoesNotExist(
        identifier: String,
        timeout: TimeInterval
    ) {
        let image = app.images[identifier]
        let exists = image.waitForNonExistence(timeout: timeout)
        XCTAssertTrue(
            exists,
            "Image with accessibility identifier \(identifier) still exists"
        )
    }

    func assertHasText(text: String) {
        let textElement = app.staticTexts[text]

        XCTAssertTrue(
            textElement.exists,
            "Text with text \(text) does not exist"
        )

        XCTAssertEqual(
            textElement.label,
            text,
            "Text with text \(text) does not match label \(textElement.label)"
        )
    }

    func onUIElement(
        identifier: String,
        accessibilityTrait: AccessibilityTraits
    ) -> XCUIElement {
        var element: XCUIElement!

        switch accessibilityTrait {
        case .isStaticText:
            element = app.staticTexts[identifier]

        case .isButton:
            element = app.buttons[identifier]

        case .isImage:
            element = app.images[identifier]

        case .isToggle:
            element = app.toggles[identifier]

        default:
            element = app.otherElements[identifier]
        }
        return element
    }

    func awaitOnScrollable(
        identifier: String,
        timeout: TimeInterval = 5
    ) -> XCUIElement {
        let scrollable = app.scrollViews[identifier]
        XCTAssertTrue(
            scrollable.waitForExistence(timeout: timeout),
            "Scrollable with accessibility identifier \(identifier) does not exist"
        )
        return scrollable
    }

    func onButton(identifier: String) -> XCUIElement {
        let button = app.buttons[identifier]
        XCTAssertTrue(
            button.exists,
            "Element with accessibility identifier \(identifier) does not exist"
        )
        return button
    }

    func waitAndAssertTextDoesNotExist(
        identifier: String,
        timeout: TimeInterval
    ) {
        let text = app.staticTexts[identifier]
        let exists = text.waitForNonExistence(timeout: timeout)
        XCTAssertTrue(
            exists,
            "Text with accessibility identifier \(identifier) still exists"
        )
    }

    func waitAndAssertTextExist(identifier: String, timeout: TimeInterval) {
        let text = app.staticTexts[identifier]
        let exists = text.waitForExistence(timeout: timeout)
        XCTAssertTrue(
            exists,
            "Text with accessibility identifier \(identifier) still does not exists"
        )
    }

    func insertText(
        identifier: String,
        text: String,
        textFieldType: TextFieldType = .normal
    ) {
        let textField =
            switch textFieldType {
            case .normal:
                app.textFields[identifier].firstMatch

            case .password:
                app.secureTextFields[identifier].firstMatch
            }

        XCTAssertTrue(
            textField.exists,
            "Enable to find textfield with identifier \(identifier)"
        )

        textField.tap()
        textField.typeText(text)
    }

    func onKeyboardReturn() {
        let keyboardReturnButton = app.keyboards.buttons["Return"]

        if keyboardReturnButton.exists && keyboardReturnButton.isHittable {
            keyboardReturnButton.tap()
        }
    }

    func onProgressIndicator(identifier: String) -> XCUIElement {
        let indicator = app.progressIndicators[identifier].firstMatch

        XCTAssertTrue(
            indicator.exists,
            "Enable to find progress indicator with identifier \(identifier)"
        )

        return indicator
    }

    func onScrollable(identifier: String, timeout: TimeInterval = 5)
        -> XCUIElement
    {
        let scrollable = app.scrollViews[identifier]
        XCTAssertTrue(
            scrollable.waitForExistence(timeout: timeout),
            "Scrollable with accessibility identifier \(identifier) does not exist"
        )
        return scrollable
    }

    func waitFor(_ timeInterval: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(timeInterval))
    }
}
