//
//  LoginForm.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-09.
//

import Combine
import CoreApp
import CoreUI
import SwiftUI

public struct LoginForm: View {

    @Binding
    private var state: LoginFormState

    private let onEvent: (LoginFormEvent) -> Void
    private let onRegisterNowClick: () -> Void
    private let onCloseClick: () -> Void
    private let onLoggedIn: (User) -> Void
    private let userHasLoggedInEvent: PassthroughSubject<User, Never>

    public init(
        state: Binding<LoginFormState>,
        userHasLoggedInEvent: PassthroughSubject<User, Never>,
        onEvent: @escaping (LoginFormEvent) -> Void,
        onRegisterNowClick: @escaping () -> Void,
        onCloseClick: @escaping () -> Void,
        onLoggedIn: @escaping (User) -> Void
    ) {
        _state = state
        self.onEvent = onEvent
        self.onRegisterNowClick = onRegisterNowClick
        self.onCloseClick = onCloseClick
        self.onLoggedIn = onLoggedIn
        self.userHasLoggedInEvent = userHasLoggedInEvent
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                if state.alertVisible {
                    WarningMessage(
                        text: state.alertText,
                        iconName: "information"
                    )
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.theme().error)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.medium))
                    .padding()
                    .shadow(radius: Theme.medium)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
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
                        leadingIconName: "lock",
                        trailingIconName: state.isPasswordVisible
                            ? "eye" : "eye-closed",
                        iconsColor: .theme().secondary,
                        onTrailingIconClick: {
                            onEvent(.togglePasswordVisible)
                        },
                        hasError: state.hasPasswordError,
                        errorContent: LocalKeys.passwordRequired
                            .localized(bundle: .coreUIBundle),
                    )
                }

                HStack {
                    Spacer()

                    Button(action: onRegisterNowClick) {
                        Text(
                            LocalKeys
                                .registerNow
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
                                .login(onError: { _ in
                                    withAnimation {
                                        onEvent(
                                            .setAlert(
                                                message: LocalKeys
                                                    .wrongLoginCredentials
                                                    .localized(
                                                        bundle: .coreUIBundle
                                                    ),
                                                visible: true
                                            )
                                        )
                                    }
                                })
                            )
                        },
                        backgroundColor: .theme().primary,
                        width: 100,
                        accessibilityIdentifier: LocalKeys.loginButtonCd
                    ) {
                        Text(LocalKeys.login.localized(bundle: .coreUIBundle))
                            .font(.bodyMedium)
                            .foregroundColor(.theme().onPrimary)
                    }
                    .padding(.trailing, 8)
                    .shadow(radius: Theme.small)
                }
            }
        }
        .animation(.easeInOut, value: state.alertVisible)
        .onReceive(userHasLoggedInEvent) { user in
            onLoggedIn(user)
        }
    }
}

private struct LoginFormPreview: View {
    @State
    private var loginFormState: LoginFormState = .init()

    var body: some View {
        LoginForm(
            state: $loginFormState,
            userHasLoggedInEvent: PassthroughSubject<User, Never>(),
            onEvent: { event in
                switch event {
                case .togglePasswordVisible:
                    loginFormState = loginFormState.copy(
                        isPasswordVisible: !loginFormState.isPasswordVisible
                    )

                case .setAlert(let message, let isVisible):
                    loginFormState = loginFormState.copy(
                        alertText: message,
                        alertVisible: isVisible
                    )

                case .login(let onError):
                    loginFormState = loginFormState.copy(shouldValidate: true)

                    if !loginFormState.hasEmailError
                        && !loginFormState.hasPasswordError
                    {
                        loginFormState = loginFormState.copy(isLoading: true)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if loginFormState.email != MockData.correctEmail {
                                onError(
                                    ApiError.requestFailed(
                                        NSError(domain: "unAuthorized", code: 1)
                                    )
                                )
                                loginFormState = loginFormState.copy(isLoading: false)
                            } else {
                                print(
                                    "login with email: \(loginFormState.email)"
                                )
                            }
                        }

                    }
                }
            },
            onRegisterNowClick: {},
            onCloseClick: {},
            onLoggedIn: { _ in }
        )
    }
}

#Preview {
    LoginFormPreview()
}
