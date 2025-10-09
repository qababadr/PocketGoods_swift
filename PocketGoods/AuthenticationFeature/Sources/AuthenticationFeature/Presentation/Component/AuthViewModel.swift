//
//  AuthViewModel.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//

@preconcurrency import Combine
import CoreApp
import Foundation

@MainActor
public class AuthViewModel: ObservableObject {

    @Published
    public var authState: AuthState = AuthState()

    @Published
    public var loginFormState: LoginFormState = LoginFormState()

    @Published
    public var registerFormState: RegisterFormState = RegisterFormState()

    private let useCases: AuthenticationUseCases?

    public let loginSuccessSubject = PassthroughSubject<User, Never>()

    private var cancellables: Set<AnyCancellable> = []

    public init(useCases: AuthenticationUseCases?) {
        self.useCases = useCases
    }

    public func onAuthEvent(event: AuthEvent) {
        switch event {
        case .onRefreshUserData(let onRefreshFailed):
            onRefreshUserData(onRefreshFailed: onRefreshFailed)
        case .setAuthenticatedUser(let user):
            setAuthenticatedUser(user: user)

        case .onLogout(let userId, let onLoggedOut, let onError):
            logout(
                userId: userId,
                onLoggedOut: onLoggedOut,
                onError: onError
            )
        }
    }

    public func onLoginFormEvent(event: LoginFormEvent) {
        switch event {
        case .togglePasswordVisible:
            togglePasswordVisible(formType: .login)

        case .setAlert(let message, let visible):
            setAlert(message: message, visible: visible, formType: .login)

        case .login(let onError):
            login(onError: onError)
        }
    }

    public func onRegisterFormEvent(event: RegisterFormEvent) {
        switch event {
        case .togglePasswordVisible:
            togglePasswordVisible(formType: .register)

        case .toggleConfirmPasswordVisible:
            toggleConfirmPasswordVisible()

        case .setAlert(let message, let visible, let alertType):
            setAlert(
                message: message,
                visible: visible,
                alertType: alertType,
                formType: .register
            )

        case .register(let onRegistered, let onError):
            register(onRegistered: onRegistered, onError: onError)

        case .onReset:
            onReset()
        }
    }

    private func onRefreshUserData(onRefreshFailed: @escaping () -> Void) {
        guard let useCases else { return }

        Task {
            await useCases
                .getAuthenticatedUser()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(_) = completion {
                            onRefreshFailed()
                        }
                    },
                    receiveValue: { [weak self] resource in
                        guard let self else { return }

                        switch resource {
                        case .success(let data):
                            authState = authState.copy(
                                authenticatedUser: data
                            )

                        case .error(_, _):
                            onRefreshFailed()

                        default:
                            break
                        }
                    }
                )
                .store(in: &cancellables)
        }
    }

    private func setAuthenticatedUser(user: User?) {
        authState = authState.copy(
            authenticatedUser: .some(user)
        )
    }

    private func logout(
        userId: Int64,
        onLoggedOut: @escaping () -> Void,
        onError: @escaping () -> Void
    ) {
        guard let useCases else { return }

        Task {
            do {
                let _ = try await useCases.logout(userId: userId)
                onLoggedOut()
            } catch {
                onError()
            }
        }
    }

    private func login(onError: @escaping (Error) -> Void) {
        guard let useCases else { return }

        loginFormState = loginFormState.copy(shouldValidate: true)
        if isValidLoginForm() {

            loginFormState = loginFormState.copy(isLoading: true)

            Task {
                do {
                    try await useCases.login(
                        email: loginFormState.email,
                        password: loginFormState.password
                    )
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        guard let self else { return }

                        if case .failure(let error) = completion {
                            loginFormState = loginFormState.copy(
                                isLoading: false
                            )
                            onError(error)
                        }

                    } receiveValue: { [weak self] user in
                        guard let self else { return }

                        if let user {
                            loginFormState = loginFormState.copy(
                                isLoading: false,
                                email: "",
                                password: "",
                                shouldValidate: false
                            )
                            authState = authState.copy(authenticatedUser: user)
                            loginSuccessSubject.send(user)
                        }

                    }
                    .store(in: &cancellables)

                } catch {
                    loginFormState = loginFormState.copy(
                        isLoading: false,
                        shouldValidate: false
                    )
                    onError(error)
                }
            }
        }
    }

    private func toggleConfirmPasswordVisible() {
        registerFormState = registerFormState.copy(
            isConfirmPasswordVisible: !registerFormState
                .isConfirmPasswordVisible
        )
    }

    private func register(
        onRegistered: @escaping (String) -> Void,
        onError: @escaping () -> Void
    ) {
        guard let useCases else { return }

        registerFormState = registerFormState.copy(shouldValidate: true)

        if isValidRegisterForm() {
            Task {
                registerFormState = registerFormState.copy(isLoading: true)

                do {
                    let _ =
                        try await useCases
                        .register(
                            fullName: registerFormState.name,
                            email: registerFormState.email,
                            password: registerFormState.password,
                            passwordConfirmation: registerFormState
                                .confirmPassword
                        )
                    onRegistered(registerFormState.name)
                    onReset()

                } catch {
                    onError()
                }

            }
        }
    }

    private func isValidRegisterForm() -> Bool {
        return !registerFormState.hasUsernameError
            && !registerFormState.hasEmailError
            && !registerFormState.hasPasswordError
            && !registerFormState.hasConfirmPasswordError
    }

    private func isValidLoginForm() -> Bool {
        return !loginFormState.hasEmailError
            && !loginFormState.hasPasswordError
    }

    private func onReset() {
        registerFormState = registerFormState.copy(
            name: "",
            email: "",
            password: "",
            confirmPassword: "",
            shouldValidate: false
        )
    }

    private func togglePasswordVisible(formType: FormType) {
        switch formType {
        case .login:
            loginFormState = loginFormState.copy(
                isPasswordVisible: !loginFormState.isPasswordVisible
            )

        case .register:
            registerFormState = registerFormState.copy(
                isPasswordVisible: !registerFormState.isPasswordVisible
            )
        }
    }

    private func setAlert(
        message: String,
        visible: Bool,
        alertType: RegisterAlertType = .error,
        formType: FormType
    ) {
        switch formType {
        case .login:
            loginFormState = loginFormState.copy(
                alertText: message,
                alertVisible: visible
            )

        case .register:
            registerFormState = registerFormState.copy(
                alertText: message,
                alertVisible: visible,
                alertType: alertType
            )
        }
    }
}
