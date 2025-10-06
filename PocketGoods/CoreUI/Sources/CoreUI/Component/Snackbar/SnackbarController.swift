//
//  SnackbarController.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import Foundation
import SwiftUI

@MainActor
public class SnackbarController: ObservableObject {

    @Published
    public var data: SnackbarData = .init()

    public init() {}

    public func show(
        message: String,
        severity: SnackbarSeverity = .info,
        duration: TimeInterval = 3
    ) {
        withAnimation(.easeIn(duration: 0.3)) {
            data = data.copy(
                message: message,
                severity: severity,
                duration: duration,
                isVisible: true
            )
        }
    }

    public func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            data = data.copy(
                message: "",
                severity: .info,
                duration: 3,
                isVisible: false
            )
        }
    }
}
