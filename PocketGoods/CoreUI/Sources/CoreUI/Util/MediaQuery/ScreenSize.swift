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
