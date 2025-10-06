//
//  DiscountAnimation.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import SwiftUI
import DotLottie

public struct DiscountAnimation: View {
    
    public let loop: Bool
    
    public init(loop: Bool = true) {
        self.loop = loop
    }
    
    public var body: some View {
        DotLottieAnimation(
            fileName: "discount_offers",
            bundle: .module,
            config: AnimationConfig(
                autoplay: true,
                loop: loop,
                useFrameInterpolation: false
            )
        )
        .view()
    }
}

#Preview {
    ScrollView {
        VStack {
            HStack {
                Spacer()
                DiscountAnimation()
                    .frame(width: 100, height: 100)
                Spacer()
            }
        }
    }
}
