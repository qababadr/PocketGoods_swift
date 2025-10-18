//
//  AuthModalContent.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-09.
//

import Combine
import CoreApp
import CoreUI
import SwiftUI

struct AuthModalContent: View {

    @Binding
    var formType: FormType

    @Binding
    var loginState: LoginFormState

    @Binding
    var registerState: RegisterFormState

    let userHasLoggedInEvent: PassthroughSubject<User, Never>

    let onLoggedIn: (User) -> Void

    let onLoginFormEvent: (LoginFormEvent) -> Void

    let onRegisterFormEvent: (RegisterFormEvent) -> Void

    @EnvironmentObject
    private var modalController: ModalController

    var body: some View {
        VStack {
            Text(
                formType == .login
                    ? LocalKeys.login.localized(bundle: .coreUIBundle)
                    : LocalKeys.register.localized(bundle: .coreUIBundle)
            )
            .foregroundColor(.theme().onPrimary)
            .font(.headlineSmall)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(Color.theme().primary)
            .padding(.bottom)

            if formType == .login {
                LoginForm(
                    state: $loginState,
                    userHasLoggedInEvent: userHasLoggedInEvent,
                    onEvent: onLoginFormEvent,
                    onRegisterNowClick: {
                        withAnimation {
                            formType = .register
                        }
                    },
                    onCloseClick: {
                        modalController.dismiss()
                    },
                    onLoggedIn: onLoggedIn
                )
                .padding(.bottom)

            } else {
                RegisterForm(
                    state: $registerState,
                    onEvent: onRegisterFormEvent,
                    onLoginClick: {
                        withAnimation {
                            formType = .login
                        }
                    },
                    onCloseClick: {
                        modalController.dismiss()
                    }
                )
                .padding(.bottom)
            }
        }
        .frame(
            height: formType == .login ? 420 : UIScreen.main.bounds.height * 0.65
        )
        .background(Color.theme().background)
    }
}
