//
//  Toolbar.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-09.
//

import Combine
import CoreApp
import CoreUI
import SwiftUI

public struct Toolbar: View {

    @Binding
    private var isDarkTheme: Bool

    @Binding
    private var formType: FormType

    @Binding
    private var loginState: LoginFormState

    @Binding
    private var registerState: RegisterFormState

    private let userHasLoggedInEvent: PassthroughSubject<User, Never>

    private let authState: AuthState

    private let onLoginFormEvent: (LoginFormEvent) -> Void
    private let onRegisterFormEvent: (RegisterFormEvent) -> Void
    private let onLogout: () -> Void
    private let onLoggedIn: (User) -> Void
    private let onUserMenuClick: () -> Void
    private let onWishlistManagerClick: () -> Void
    private let onDarkThemeSwitched: (Bool) -> Void

    @EnvironmentObject
    private var modalController: ModalController

    public init(
        isDarkTheme: Binding<Bool>,
        authState: AuthState,
        formType: Binding<FormType>,
        loginState: Binding<LoginFormState>,
        userHasLoggedInEvent: PassthroughSubject<User, Never>,
        onLoginFormEvent: @escaping (LoginFormEvent) -> Void,
        registerState: Binding<RegisterFormState>,
        onRegisterFormEvent: @escaping (RegisterFormEvent) -> Void,
        onLogout: @escaping () -> Void,
        onLoggedIn: @escaping (User) -> Void,
        onUserMenuClick: @escaping () -> Void,
        onWishlistManagerClick: @escaping () -> Void,
        onDarkThemeSwitched: @escaping (Bool) -> Void
    ) {
        self.authState = authState
        _formType = formType
        _loginState = loginState
        _isDarkTheme = isDarkTheme
        self.onLoginFormEvent = onLoginFormEvent
        _registerState = registerState
        self.onRegisterFormEvent = onRegisterFormEvent
        self.onLogout = onLogout
        self.onLoggedIn = onLoggedIn
        self.onUserMenuClick = onUserMenuClick
        self.onWishlistManagerClick = onWishlistManagerClick
        self.onDarkThemeSwitched = onDarkThemeSwitched
        self.userHasLoggedInEvent = userHasLoggedInEvent
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            if let authenticatedUser = authState.authenticatedUser {
                UserMenu(
                    onLogout: onLogout,
                    onClick: onUserMenuClick,
                    onWishlistManagerClick: onWishlistManagerClick,
                    onDarkThemeSwitched: onDarkThemeSwitched,
                    initials: authenticatedUser.name.stringAvatar(),
                    wishlistCount: authenticatedUser.wishlist.count,
                    isDarkTheme: $isDarkTheme
                )
            } else {
                Button(
                    action: {
                        modalController.show {
                            AuthModalContent(
                                formType: $formType,
                                loginState: $loginState,
                                registerState: $registerState,
                                userHasLoggedInEvent: userHasLoggedInEvent,
                                onLoggedIn: onLoggedIn,
                                onLoginFormEvent:
                                    onLoginFormEvent,
                                onRegisterFormEvent:
                                    onRegisterFormEvent
                            )
                        }
                    }
                ) {
                    HStack(alignment: .center, spacing: 4) {
                        Text(LocalKeys.login.localized(bundle: .coreUIBundle))
                            .font(.bodyMedium)
                            .foregroundColor(.theme().onPrimary)

                        Image("login", bundle: .coreUIBundle)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                            .tint(.theme().onPrimary)
                    }
                }
                .accessibilityIdentifier(LocalKeys.toolbarLoginCd)
            }
        }
    }
}

private struct ToolbarPreview: View {

    @State
    private var isDarkTheme: Bool = false

    @State
    private var authState: AuthState = AuthState()

    @State
    private var formType: FormType = .login

    @State
    public var loginFormState: LoginFormState = LoginFormState()

    @State
    private var registerState: RegisterFormState = RegisterFormState()

    private let userHasLoggedInEvent = PassthroughSubject<User, Never>()

    @StateObject
    private var modalController = ModalController()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Toolbar(
                    isDarkTheme: $isDarkTheme,
                    authState: authState,
                    formType: $formType,
                    loginState: $loginFormState,
                    userHasLoggedInEvent: userHasLoggedInEvent,
                    onLoginFormEvent: { event in
                        switch event {
                            
                        case .togglePasswordVisible:
                            loginFormState = loginFormState.copy(
                                isPasswordVisible: !loginFormState.isPasswordVisible
                            )
                        case .setAlert(let message, let visible):
                            loginFormState = loginFormState.copy(
                                alertText: message,
                                alertVisible: visible
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
                                        loginFormState = loginFormState.copy(
                                            isLoading: false
                                        )
                                    } else {
                                        loginFormState = loginFormState.copy(
                                            isLoading: false,
                                        )
                                        
                                        authState = authState.copy(
                                            authenticatedUser: MockData.userDTO.toUser()
                                        )
                                        
                                        modalController.dismiss()
                                    }
                                }
                            }
                        }
                    },
                    registerState: $registerState,
                    onRegisterFormEvent: { event in
                        switch event {
                            
                        case .togglePasswordVisible:
                            registerState = registerState.copy(
                                isPasswordVisible: !registerState.isPasswordVisible
                            )
                        case .toggleConfirmPasswordVisible:
                            registerState = registerState.copy(
                                isConfirmPasswordVisible: !registerState
                                    .isConfirmPasswordVisible
                            )
                        case .setAlert(let message, let visible, let alertType):
                            registerState = registerState.copy(
                                alertText: message,
                                alertVisible: visible,
                                alertType: alertType
                            )
                        case .register(let onRegistered, let onError):
                            registerState = registerState.copy(shouldValidate: true)
                            
                            if !registerState.hasUsernameError
                                && !registerState.hasEmailError
                                && !registerState.hasPasswordError
                                && !registerState.hasConfirmPasswordError
                            {
                                registerState = registerState.copy(isLoading: true)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    if registerState.email == MockData.correctEmail {
                                        onError()
                                    } else {
                                        onRegistered(registerState.name)
                                    }
                                    registerState = registerState.copy(
                                        isLoading: false,
                                        name: "",
                                        email: "",
                                        password: "",
                                        confirmPassword: "",
                                        shouldValidate: false
                                    )
                                }
                            }
                            
                        case .onReset:
                            registerState = registerState.copy(
                                name: "",
                                email: "",
                                password: "",
                                confirmPassword: "",
                                shouldValidate: false
                            )
                        }
                    },
                    onLogout: {
                        if authState.authenticatedUser != nil {
                            authState = authState.copy(
                                authenticatedUser: .some(nil)
                            )
                        }
                    },
                    onLoggedIn: { _ in
                        
                    },
                    onUserMenuClick: {},
                    onWishlistManagerClick: {},
                    onDarkThemeSwitched: { isDarkTheme in },
                )
                .padding(.trailing, 8)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme().secondary)
        .modalHost()
        .environmentObject(modalController)
    }
}

#Preview {
    ToolbarPreview()
}
