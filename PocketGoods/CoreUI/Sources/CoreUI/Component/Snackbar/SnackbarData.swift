//
//  SnackbarData.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//
import Foundation

public struct SnackbarData {
    public let message: String
    public let severity: SnackbarSeverity
    public let duration: TimeInterval
    public let isVisible: Bool
    public let icon: SnackbarIcon

    public init(
        message: String = "",
        severity: SnackbarSeverity = .success,
        duration: TimeInterval = 3,
        isVisible: Bool = false,
    ) {
        self.message = message
        self.severity = severity
        self.duration = duration
        self.isVisible = isVisible
        self.icon = severity.getAssetIcon()
    }

    public func copy(
        message: String? = nil,
        severity: SnackbarSeverity? = nil,
        duration: TimeInterval? = nil,
        isVisible: Bool? = nil
    ) -> SnackbarData {
        return SnackbarData(
            message: message ?? self.message,
            severity: severity ?? self.severity,
            duration: duration ?? self.duration,
            isVisible: isVisible ?? self.isVisible
        )
    }
}
