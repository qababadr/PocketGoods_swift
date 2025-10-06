//
//  SnackbarSeverity.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

@frozen
public enum SnackbarSeverity {
    case success
    case error
    case info
    case warning
}

extension SnackbarSeverity {

    public func getIconResourceName() -> String {
        return switch self {
        case .success:
            "checkmark.circle.fill"
        case .error:
            "exclamationmark.circle.fill"
        case .info:
            "info.circle.fill"
        case .warning:
            "exclamationmark.triangle.fill"
        }
    }

    public func getAssetIcon() -> SnackbarIcon {
        return switch self {
        case .success:
            .successIcon
        case .error:
            .errorIcon
        case .info, .warning:
            .warningIcon
        }
    }
}
