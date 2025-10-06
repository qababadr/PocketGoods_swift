//
//  ProgressButton.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-06.
//

import SwiftUI

public struct ProgressButton<Content: View, ButtonShape: Shape>: View {

    private let isLoading: Bool
    private let action: () -> Void
    private let content: Content
    private let tint: Color
    private let backgroundColor: Color
    private let shape: ButtonShape
    private let width: CGFloat
    private let accessibilityIdentifier: String

    public init(
        isLoading: Bool,
        action: @escaping () -> Void,
        tint: Color = .white,
        backgroundColor: Color = .green,
        shape: ButtonShape = RoundedRectangle(cornerRadius: 6),
        width: CGFloat = 120,
        accessibilityIdentifier: String = "ProgressButton",
        @ViewBuilder content: @escaping () -> Content,
    ) {
        self.isLoading = isLoading
        self.action = action
        self.content = content()
        self.tint = tint
        self.backgroundColor = backgroundColor
        self.shape = shape
        self.width = width
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    public var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {

                if isLoading {
                    ProgressView()
                        .frame(height: 12)
                        .tint(tint)
                        .accessibilityIdentifier("Loading")
                }

                content

            }
            .opacity(isLoading ? 0.7 : 1)
        }
        .disabled(isLoading)
        .accessibilityIdentifier(accessibilityIdentifier)
        .padding(.all, 8)
        .frame(width: width)
        .background(
            backgroundColor.opacity(
                isLoading ? 0.7 : 1
            )
        )
        .clipShape(shape)
    }
}

private struct ProgressButtonPreview: View {

    @State
    private var isLoading: Bool = false

    var body: some View {
        ProgressButton(
            isLoading: isLoading,
            action:  {
                isLoading.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isLoading.toggle()
                }
                
            },
            backgroundColor: .theme().primary,
            width: 200
        ) {
            Text("Progress Button")
                .foregroundColor(.theme().onPrimary)
        }
        .shadow(radius: Theme.medium)
    }
}

#Preview {
    ProgressButtonPreview()
}
