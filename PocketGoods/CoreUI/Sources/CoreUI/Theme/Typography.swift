//
//  Typography.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//
import SwiftUI

public extension Font {
    static let displayLarge = Font.lato(.regular, size: .fontDisplayLarge)
    static let displayMedium = Font.lato(.regular, size: .fontDisplayMedium)
    static let displaySmall = Font.lato(.regular, size: .fontDisplaySmall)
    
    static let headlineLarge = Font.lato(.regular, size: .fontHeadlineLarge)
    static let headlineMedium = Font.lato(.regular, size: .fontHeadlineMedium)
    static let headlineSmall = Font.lato(.regular, size: .fontHeadlineSmall)
    
    static let titleLarge = Font.lato(.regular, size: .fontTitleLarge)
    static let titleMedium = Font.lato(.regular, size: .fontTitleMedium)
    static let titleSmall = Font.lato(.regular, size: .fontTitleSmall)
    
    static let bodyLarge = Font.lato(.regular, size: .fontBodyLarge)
    static let bodyMedium = Font.lato(.regular, size: .fontBodyMedium)
    
    static let labelLarge = Font.lato(.regular, size: .fontLabelLarge)
    static let labelMedium = Font.lato(.regular, size: .fontLabelMedium)
    static let labelSmall = Font.lato(.regular, size: .fontLabelSmall)
}

public extension CGFloat {
    static let fontDisplayLarge: CGFloat = 30
    static let fontDisplayMedium: CGFloat = 24
    static let fontDisplaySmall: CGFloat = 20
    
    static let fontHeadlineLarge: CGFloat = 20
    static let fontHeadlineMedium: CGFloat = 18
    static let fontHeadlineSmall: CGFloat = 16
    
    static let fontTitleLarge: CGFloat = 19
    static let fontTitleMedium: CGFloat = 17
    static let fontTitleSmall: CGFloat = 15
    
    static let fontBodyLarge: CGFloat = 17
    static let fontBodyMedium: CGFloat = 14
    
    static let fontLabelLarge: CGFloat = 15
    static let fontLabelMedium: CGFloat = 12
    static let fontLabelSmall: CGFloat = 10
}
