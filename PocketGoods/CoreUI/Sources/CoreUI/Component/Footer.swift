//
//  Footer.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-06.
//

import SwiftUI

public struct Footer: View {

    private let footerHeight: CGFloat

    private let accessibilityID: String

    public init(
        footerHeight: CGFloat = 120,
        accessibilityID: String = "Footer"
    ) {
        self.footerHeight = footerHeight
        self.accessibilityID = accessibilityID
    }

    public var body: some View {
        VStack {
            Text(
                LocalKeys
                    .txtCopyRight
                    .localized(
                        bundle: .module,
                        LocalKeys
                            .appName
                            .localized(bundle: .module)
                    )
            )
            .font(.bodyMedium)
            .foregroundColor(.theme().onPrimary)
            .accessibilityIdentifier(accessibilityID)
        }
        .frame(maxWidth: .infinity)
        .frame(height: footerHeight)
        .background(Color.theme().primary)
    }
}

#Preview {
    VStack {
        Spacer()
        Footer(footerHeight: 90)
    }
}
