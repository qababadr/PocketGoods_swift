//
//  RegisterForm.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-09.
//

import CoreApp
import CoreUI
import SwiftUI

public struct RegisterForm: View {

    @Binding
    private var state: RegisterFormState

    private let onEvent: (RegisterFormEvent) -> Void
    private let onLoginClick: () -> Void
    private let onCloseClick: () -> Void

    public init(
        state: Binding<RegisterFormState>,
        onEvent: @escaping (RegisterFormEvent) -> Void,
        onLoginClick: @escaping () -> Void,
        onCloseClick: @escaping () -> Void
    ) {
        _state = state
        self.onEvent = onEvent
        self.onLoginClick = onLoginClick
        self.onCloseClick = onCloseClick
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                if state.alertVisible {
                    WarningMessage(
                        text: state.alertText,
                        iconName: state.alertType == .success
                            ? "check-circle" : "information"
                    )
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        state.alertType == .success
                            ? Color.theme().success : Color.theme().error
                    )
                    .clipShape(RoundedRectangle(cornerRadius: Theme.medium))
                    .padding()
                    .shadow(radius: Theme.medium)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))

                }

                VStack(alignment: .leading) {
                    Text(LocalKeys.fullName.localized(bundle: .coreUIBundle))
                        .font(.bodyMedium)
                        .foregroundColor(.theme().secondary)
                        .padding(.leading)

                    TextInput(
                        value: $state.name,
                        label: "",
                        accessibilityIdentifier: LocalKeys.fullName,
                        leadingIconName: "tag",
                        iconsColor: .theme().secondary,
                        hasError: state.hasUsernameError,
                        errorContent: LocalKeys.fullNameError
                            .localized(bundle: .coreUIBundle),
                    )
                }

                VStack(alignment: .leading) {
                    Text(LocalKeys.email.localized(bundle: .coreUIBundle))
                        .font(.bodyMedium)
                        .foregroundColor(.theme().secondary)
                        .padding(.leading)

                    TextInput(
                        value: $state.email,
                        label: "",
                        accessibilityIdentifier: LocalKeys.email,
                        leadingIconName: "email-outline",
                        iconsColor: .theme().secondary,
                        hasError: state.hasEmailError,
                        errorContent: LocalKeys.emailError
                            .localized(bundle: .coreUIBundle),
                    )
                }

                VStack(alignment: .leading) {
                    Text(LocalKeys.password.localized(bundle: .coreUIBundle))
                        .font(.bodyMedium)
                        .foregroundColor(.theme().secondary)
                        .padding(.leading)

                    TextInput(
                        value: $state.password,
                        label: "",
                        inputType: state.isPasswordVisible ? .text : .password,
                        accessibilityIdentifier: LocalKeys.password,
                        trailingIconAI: LocalKeys.passwordVisibleToggleCd,
                        leadingIconName: "lock",
                        trailingIconName: state.isPasswordVisible
                            ? "eye" : "eye-closed",
                        iconsColor: .theme().secondary,
                        onTrailingIconClick: {
                            onEvent(.togglePasswordVisible)
                        },
                        hasError: state.hasPasswordError,
                        errorContent: LocalKeys.passwordError
                            .localized(bundle: .coreUIBundle)
                    )
                }

                VStack(alignment: .leading) {
                    Text(
                        LocalKeys.confirmPassword.localized(
                            bundle: .coreUIBundle
                        )
                    )
                    .font(.bodyMedium)
                    .foregroundColor(.theme().secondary)
                    .padding(.leading)

                    TextInput(
                        value: $state.confirmPassword,
                        label: "",
                        inputType: state.isConfirmPasswordVisible
                            ? .text : .password,
                        accessibilityIdentifier: LocalKeys.confirmPassword,
                        trailingIconAI: LocalKeys
                            .conformPasswordVisibleToggleCd,
                        leadingIconName: "lock",
                        trailingIconName: state.isConfirmPasswordVisible
                            ? "eye" : "eye-closed",
                        iconsColor: .theme().secondary,
                        onTrailingIconClick: {
                            onEvent(.toggleConfirmPasswordVisible)
                        },
                        hasError: state.hasConfirmPasswordError,
                        errorContent: LocalKeys.confirmPasswordError
                            .localized(bundle: .coreUIBundle),
                    )
                }

                HStack {
                    Spacer()
                    Button(action: onLoginClick) {
                        Text(
                            LocalKeys
                                .alreadyRegistered
                                .localized(bundle: .coreUIBundle)
                                .capitalized
                        )
                        .font(.bodyLarge)
                        .foregroundColor(.theme().primary)
                        .underline()
                    }
                    .accessibilityIdentifier(LocalKeys.alreadyRegistered)
                    Spacer()
                }

                Divider()

                Spacer()

                HStack(alignment: .center, spacing: 10) {
                    Spacer()

                    Button(action: onCloseClick) {
                        Text(LocalKeys.close.localized(bundle: .coreUIBundle))
                            .font(.bodyMedium)
                            .foregroundColor(.theme().onPrimary)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.theme().secondary)
                    .shadow(radius: Theme.small)

                    ProgressButton(
                        isLoading: state.isLoading,
                        action: {
                            onEvent(
                                .register(
                                    onRegistered: { username in
                                        withAnimation(.easeInOut) {
                                            onEvent(
                                                .setAlert(
                                                    message: LocalKeys
                                                        .registered
                                                        .localized(
                                                            bundle:
                                                                .coreUIBundle,
                                                            username
                                                        ),
                                                    visible: true,
                                                    alertType: .success
                                                )
                                            )
                                        }
                                    },
                                    onError: {
                                        withAnimation(.easeInOut) {
                                            onEvent(
                                                .setAlert(
                                                    message: LocalKeys
                                                        .registrationError
                                                        .localized(
                                                            bundle:
                                                                .coreUIBundle
                                                        ),
                                                    visible: true,
                                                    alertType: .error
                                                )
                                            )
                                        }
                                    }
                                )
                            )
                        },
                        backgroundColor: .theme().primary,
                        width: 100,
                        accessibilityIdentifier: LocalKeys.registerButtonCd
                    ) {
                        Text(
                            LocalKeys.register.localized(bundle: .coreUIBundle)
                        )
                        .font(.bodyMedium)
                        .foregroundColor(.theme().onPrimary)
                    }
                    .padding(.trailing, 8)
                    .shadow(radius: Theme.small)
                }
            }
        }
    }
}

private struct RegisterFormPreview: View {

    @State
    private var state: RegisterFormState = .init()

    var body: some View {
        RegisterForm(
            state: $state,
            onEvent: { event in
                switch event {

                case .togglePasswordVisible:
                    state = state.copy(
                        isPasswordVisible: !state.isPasswordVisible
                    )

                case .toggleConfirmPasswordVisible:
                    state = state.copy(
                        isConfirmPasswordVisible: !state
                            .isConfirmPasswordVisible
                    )

                case .setAlert(let message, let visible, let alertType):
                    state = state.copy(
                        alertText: message,
                        alertVisible: visible,
                        alertType: alertType
                    )

                case .register(let onRegistered, let onError):
                    state = state.copy(shouldValidate: true)

                    if !state.hasUsernameError
                        && !state.hasEmailError
                        && !state.hasPasswordError
                        && !state.hasConfirmPasswordError
                    {
                        state = state.copy(isLoading: true)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                            if state.email == MockData.correctEmail {
                                onError()
                            } else {
                                onRegistered(state.name)
                            }
                            state = state.copy(isLoading: false)
                        }
                    }

                case .onReset:
                    state = state.copy(
                        name: "",
                        email: "",
                        password: "",
                        confirmPassword: "",
                        shouldValidate: false
                    )
                }
            },
            onLoginClick: {},
            onCloseClick: {}
        )
    }
}

#Preview {
    RegisterFormPreview()
}
