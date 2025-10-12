//
//  LatoFontLoader.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//
import SwiftUI

public enum Lato: String, CaseIterable {
    case bold = "lato_bold"
    case italic = "lato_italic"
    case regular = "lato_regular"
}

extension Font {
    public static func lato(_ lato: Lato, size: CGFloat) -> Font {
        switch lato {
        case .bold:
            return .custom("Lato-Bold", size: size)
        case .regular:
            return .custom("Lato-Regular", size: size)
        case .italic:
            return .custom("Lato-Italic", size: size)
        }
    }
}

public struct LatoFont {

    public static func registerFonts() {
        Lato.allCases.forEach {
            register(
                bundle: .module,
                fontName: $0.rawValue,
                fontExtension: "ttf"
            )
        }
    }

    fileprivate static func register(
        bundle: Bundle,
        fontName: String,
        fontExtension: String
    ) {
        guard
            let fontURL = bundle.url(
                forResource: fontName,
                withExtension: fontExtension
            ),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider)
        else {
            fatalError(
                "Could not create font from file: \(fontName).\(fontExtension)"
            )
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
