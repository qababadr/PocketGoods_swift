//
//  Page401.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import DotLottie
import SwiftUI

public struct Page401: View {

    private let onBackHomeClick: () -> Void

    public init(onBackHomeClick: @escaping () -> Void) {
        self.onBackHomeClick = onBackHomeClick
    }

    public var body: some View {
        ZStack {
            DotLottieAnimation(
                fileName: "zero_purchase",
                bundle: .module,
                config: AnimationConfig(
                    autoplay: true,
                    loop: true,
                    useFrameInterpolation: false
                )
            )
            .view()

            VStack(spacing: 12) {

                Text(
                    LocalKeys
                        .txt404
                        .localized(bundle: .module)
                )
                .font(.bodyLarge)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .foregroundColor(.theme().onBackground)
                .fixedSize(horizontal: false, vertical: true)

                Button(action: onBackHomeClick) {
                    HStack(alignment: .center, spacing: 6) {
                        Image("home", bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                            .foregroundColor(.theme().onPrimary)

                        Text(
                            LocalKeys
                                .returnHome
                                .localized(bundle: .module)
                        )
                        .font(.titleSmall)
                        .foregroundColor(.theme().onPrimary)
                    }
                }
                .padding(.all, 6)
                .background(Color.theme().primary)
                .clipShape(RoundedRectangle(cornerRadius: Theme.medium))
                .padding()
            }
            .padding(.top, 450)
        }
    }
}

#Preview {
    Page401(onBackHomeClick: {

    })
}
