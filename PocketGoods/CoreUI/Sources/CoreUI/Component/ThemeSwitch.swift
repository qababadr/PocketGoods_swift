//
//  ThemeSwitch.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-06.
//

import SwiftUI

public struct ThemeSwitch: View {

    @Binding
    private var isDarkTheme: Bool

    private let label: String

    private let onToggle: (Bool) -> Void

    public init(
        isDarkTheme: Binding<Bool>,
        onToggle: @escaping (Bool) -> Void = { _ in },
        label: String = ""
    ) {
        _isDarkTheme = isDarkTheme
        self.label = label
        self.onToggle = onToggle
    }

    public var body: some View {
        Toggle(
            label,
            isOn: $isDarkTheme
        )
        .onChange(of: isDarkTheme) { isDarkTheme in
            onToggle(isDarkTheme)
        }
        .toggleStyle(IconToggleStyle())
    }
}

private struct IconToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            ZStack {
                Capsule()
                    .fill(
                        configuration.isOn
                            ? Color.theme().primary : Color.gray.opacity(0.4)
                    )
                    .frame(width: 50, height: 30)

                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 26, height: 26)
                            .offset(
                                x: configuration.isOn ? 10 : -10
                            )

                        Image(
                            configuration.isOn
                                ? "moon-waning-crescent"
                                : "white-balance-sunny",
                            bundle: .module
                        )
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundColor(
                            configuration.isOn
                                ? .theme().primary : .theme().warning
                        )
                        .offset(
                            x: configuration.isOn ? 10 : -10
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
            .accessibilityIdentifier(LocalKeys.switchThemeUserMenuCd)
            .accessibilityAddTraits(.isButton)
            .animation(.easeOut, value: configuration.isOn)
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}

private struct ThemeSwitchPreview: View {

    @State
    private var isDarkTheme: Bool = false

    var body: some View {
        ThemeSwitch(isDarkTheme: $isDarkTheme, label: "Theme Switch")
    }

}

#Preview {
    ThemeSwitchPreview()
}
