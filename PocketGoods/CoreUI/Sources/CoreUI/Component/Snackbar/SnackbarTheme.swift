//
//  SnackbarTheme.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//
import SwiftUI

extension Color {
    public static let snackbarSuccessBackground = Color(
           "Success",
           bundle: .module
       )
       public static let snackbarOnSuccessBackground = Color(
           "OnPrimary",
           bundle: .module
       )

       public static let snackbarErrorBackground = Color("Error", bundle: .module)
       public static let snackbarOnErrorBackground = Color(
           "OnPrimary",
           bundle: .module
       )

       public static let snackbarInfoBackground = Color("Info", bundle: .module)
       public static let snackbarOnInfoBackground = Color(
           "OnPrimary",
           bundle: .module
       )

       public static let snackbarWarningBackground = Color(
           "Warning",
           bundle: .module
       )
       public static let snackbarOnWarningBackground = Color(
           "OnWarning",
           bundle: .module
       )
    
    public static func snackbarBackgroundColor(_ severity: SnackbarSeverity) -> Color {
        return switch severity {
        case .success:
            .snackbarSuccessBackground
        case .error:
            .snackbarErrorBackground
        case .info:
            .snackbarInfoBackground
        case .warning:
            .snackbarWarningBackground
        }
    }
    
    public static func snackbarOnBackgroundColor(_ severity: SnackbarSeverity)
        -> Color
    {
        return switch severity {
        case .success:
            .snackbarOnSuccessBackground
        case .error:
            .snackbarOnErrorBackground
        case .info:
            .snackbarOnInfoBackground
        case .warning:
            .snackbarOnWarningBackground
        }
    }
}
