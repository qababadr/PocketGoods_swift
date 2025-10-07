//
//  ScreenSize.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import SwiftUI

public enum ScreenSize {
    case small
    case medium
    case large
    case xlarge
}

extension ScreenSize {
    public func getGridLayoutColumns() -> CGFloat {
        return switch self {
        case .xlarge, .large:
            3
        case .medium:
            2
        case .small:
            1
        }
    }
}

extension CGSize {
    public func getScreenSize() -> ScreenSize {
        return switch width {
        case 840...:
            .xlarge
        case 600...:
            .large
        case 480...:
            .medium
        default:
            .small
        }
    }
}
