//
//  LoadMoreTrigger.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import SwiftUI

public struct LoadMoreTrigger: View {

    @State
    private var hasBeenTriggered = false

    private let onTrigger: () -> Void

    private let threshold: CGFloat

    public init(
        threshold: CGFloat = 50,
        onTrigger: @escaping () -> Void
    ) {
        self.onTrigger = onTrigger
        self.threshold = threshold
    }

    public var body: some View {
        GeometryReader { geometry in
            Color
                .clear
                .preference(
                    key: BottomReachedPreferenceKey.self,
                    value:
                        geometry
                        .frame(in: .global)
                        .minY
                )
                .frame(height: 1)
                .onPreferenceChange(BottomReachedPreferenceKey.self) { minY in
                    let screenHeight = UIScreen.main.bounds.height

                    if minY < screenHeight + threshold && !hasBeenTriggered {
                        hasBeenTriggered = true
                        onTrigger()
                    }
                }
        }
    }

    public func resetTrigger(_ reset: Binding<Bool>) -> some View {
        onChange(of: reset.wrappedValue) { newValue in
            if newValue == true {
                hasBeenTriggered = false
                DispatchQueue.main.async {
                    reset.wrappedValue = false
                }
            }
        }
    }

    @MainActor
    private struct BottomReachedPreferenceKey: @preconcurrency PreferenceKey {
        static var defaultValue: CGFloat = 0

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}
