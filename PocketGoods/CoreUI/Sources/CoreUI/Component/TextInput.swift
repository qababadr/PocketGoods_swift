//
//  TextInput.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-06.
//

import SwiftUI

public enum InputType {
    case text, password
}

public struct TextInput: View {

    @Binding
    private var value: String

    @FocusState
    private var isFocused: Bool

    private let inputType: InputType
    private let label: String
    private let keyboardType: UIKeyboardType
    private let onChange: (String) -> Void
    private let onSubmit: () -> Void
    private let onFocusChange: (Bool) -> Void
    private let accessibilityIdentifier: String
    private let leadingIconName: String?
    private let trailingIconName: String?
    private let clearable: Bool
    private let isProcessing: Bool
    private let onTrailingIconClick: () -> Void
    private let onClearClick: () -> Void
    private let iconsColor: Color
    private let trailingIconAI: String
    private let hasError: Bool
    private let borderColor: Color
    private let innerPadding: CGFloat
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat
    private let errorContent: String?

    public init(
        value: Binding<String>,
        isFocused: FocusState<Bool>.Binding? = nil,
        label: String = "",
        inputType: InputType = .text,
        keyboardType: UIKeyboardType = .default,
        onChange: @escaping (String) -> Void = { _ in },
        onSubmit: @escaping () -> Void = {},
        onFocusedChange: @escaping (Bool) -> Void = { _ in },
        accessibilityIdentifier: String = "textField",
        trailingIconAI: String = "trailing icon button",
        leadingIconName: String? = nil,
        trailingIconName: String? = nil,
        clearable: Bool = false,
        isProcessing: Bool = false,
        iconsColor: Color = .green,
        onTrailingIconClick: @escaping () -> Void = {},
        onClearClick: @escaping () -> Void = {},
        hasError: Bool = false,
        borderColor: Color = .gray,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 1,
        innerPadding: CGFloat = 10,
        errorContent: String? = "",
    ) {
        _value = value
        self.label = label
        self.inputType = inputType
        self.onChange = onChange
        self.onSubmit = onSubmit
        self.keyboardType = keyboardType
        self.accessibilityIdentifier = accessibilityIdentifier
        self.onFocusChange = onFocusedChange
        self.leadingIconName = leadingIconName
        self.trailingIconName = trailingIconName
        self.clearable = clearable
        self.isProcessing = isProcessing
        self.iconsColor = iconsColor
        self.onTrailingIconClick = onTrailingIconClick
        self.onClearClick = onClearClick
        self.trailingIconAI = trailingIconAI
        self.hasError = hasError
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.innerPadding = innerPadding
        self.cornerRadius = cornerRadius
        self.errorContent = errorContent
    }

    public var body: some View {
        VStack {
            HStack {

                if let leadingIconName {
                    Image(leadingIconName, bundle: .module)
                        .foregroundColor(
                            hasError ? .theme().error : borderColor
                        )
                }

                Group {
                    if inputType == .text {
                        TextField(
                            "",
                            text: $value,
                            prompt: Text(label)
                                .font(.bodyMedium)
                                .foregroundColor(.theme().secondary)
                        )
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    } else {
                        SecureField(
                            "",
                            text: $value,
                            prompt: Text(label)
                                .font(.bodyMedium)
                                .foregroundColor(.theme().secondary)
                        )
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .textContentType(nil)
                    }
                }
                .focused($isFocused)
                .keyboardType(keyboardType)
                .onChange(of: value) { newValue in
                    onChange(newValue)
                }
                .onChange(of: isFocused) { newValue in
                    onFocusChange(newValue)
                }
                .onSubmit {
                    onSubmit()
                }
                .accessibilityIdentifier(accessibilityIdentifier)
                .foregroundColor(.theme().onBackground)

                if isProcessing {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.theme().primary)
                        .accessibilityIdentifier(
                            LocalKeys.searchInputLoadingIndicatorCd
                        )
                        .padding(.horizontal, 6)
                }

                if !value.isEmpty && clearable {
                    Button(action: {
                        value = ""
                        onClearClick()
                    }) {
                        Image("close-circle", bundle: .module)
                            .foregroundColor(iconsColor)
                    }
                }

                if let trailingIconName {
                    Button(action: onTrailingIconClick) {
                        Image(trailingIconName, bundle: .module)
                            .foregroundColor(iconsColor)
                    }
                    .accessibilityIdentifier(trailingIconAI)
                }
            }
            .padding(innerPadding)
            .background(Color.theme().background)
            .cornerRadius(cornerRadius)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        hasError ? .theme().error : borderColor,
                        lineWidth: borderWidth
                    )
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)

            if hasError,
                let errorContent
            {
                Text(errorContent)
                    .font(.labelSmall)
                    .foregroundColor(.theme().error)
                    .padding(.horizontal, 18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct TextInputPreview: View {
    @State
    private var value: String = ""

    @State
    private var isProcessing: Bool = false

    @State
    private var hasError: Bool = false

    var body: some View {
        TextInput(
            value: $value,
            label: "Email",
            onChange: { newValue in
                hasError = newValue.isEmpty

                Task {
                    if !newValue.isEmpty {
                        isProcessing.toggle()

                        try? await Task.sleep(nanoseconds: 1_700_000_000)

                        isProcessing.toggle()
                    }
                }

            },
            leadingIconName: "email-outline",
            trailingIconName: "magnify",
            isProcessing: isProcessing,
            iconsColor: Color.gray,
            hasError: hasError,
            errorContent: "Email is required",
        )
    }
}

#Preview {
    TextInputPreview()
}
