//
//  LikeableIconButton.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-07.
//

import CoreUI
import SwiftUI

struct LikeableIconButton: View {

    private let isLiked: Bool
    private let onLikeClicked: () -> Void
    private let iconSize: CGFloat
    
    @State
    private var isAnimating: Bool = false

    init(
        isLiked: Bool,
        onLikeClicked: @escaping () -> Void,
        iconSize: CGFloat
    ) {
        self.isLiked = isLiked
        self.onLikeClicked = onLikeClicked
        self.iconSize = iconSize
    }

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                isAnimating = true
            }
            
            onLikeClicked()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isAnimating = false
                }
            }
            
        }) {
            Image(isLiked ? "heart" : "heart_outline", bundle: .coreUIBundle)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .scaleEffect(isAnimating ? 1.3 : 1.0)
                .foregroundColor(isLiked ? .theme().error : .theme().onSurface)
        }
        .padding(.all, 8)
        .background(Color.theme().background)
        .clipShape(Circle())
    }
}

private struct LikeableIconButtonPreview: View {
    
    @State
    private var isLiked: Bool = false
    
    var body: some View {
        LikeableIconButton(
            isLiked: isLiked,
            onLikeClicked: { isLiked.toggle() },
            iconSize: 26
        )
    }
}

#Preview {
    LikeableIconButtonPreview()
}
