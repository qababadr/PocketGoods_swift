//
//  SpalshScreen.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-12.
//

import CoreUI
import SwiftUI

struct SpalshScreen: View {
    var body: some View {
        ZStack {
            Image("full_logo", bundle: .coreUIBundle)
                .resizable()
                .scaledToFit()
                .frame(width: 173, height: 136)
                .accessibilityIdentifier(UIConstants.splashScreenImageKey)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.splashTheme().background)
        .ignoresSafeArea()
    }
}

#Preview {
    SpalshScreen()
}
