//
//  HeaderSection.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//

import AuthenticationFeature
import Combine
import CoreApp
import CoreUI
import ProductFeature
import SwiftUI

struct HeaderSection: View {

    private let typingText: String

    private let authState: AuthState
    private let onAuthEvent: (AuthEvent) -> Void

    private let productState: ProductState
    private let onProductEvent: (ProductEvent) -> Void

    private let onPocketGoodsAppEvent: (PocketGoodsAppEvent) -> Void

    @Binding
    private var loginFormState: LoginFormState
    private let onLoginEvent: (LoginFormEvent) -> Void

    @Binding
    private var registerFormState: RegisterFormState
    private let onRegisterEvent: (RegisterFormEvent) -> Void

    private let userHasLoggedInEvent: PassthroughSubject<User, Never>

    @State
    private var formType: FormType = .login

    @Binding
    private var searchQuery: String

    @Binding
    private var isDarkTheme: Bool

    @EnvironmentObject
    private var router: Router

    @EnvironmentObject
    private var snackbarController: SnackbarController

    @EnvironmentObject
    private var modalController: ModalController

    init(
        authState: AuthState,
        onAuthEvent: @escaping (AuthEvent) -> Void,
        productState: ProductState,
        onProductEvent: @escaping (ProductEvent) -> Void,
        onPocketGoodsAppEvent: @escaping (PocketGoodsAppEvent) -> Void,
        loginFormState: Binding<LoginFormState>,
        onLoginEvent: @escaping (LoginFormEvent) -> Void,
        registerFormState: Binding<RegisterFormState>,
        onRegisterEvent: @escaping (RegisterFormEvent) -> Void,
        isDarkTheme: Binding<Bool>,
        searchQuery: Binding<String>,
        userHasLoggedInEvent: PassthroughSubject<User, Never>,
        typingText: String
    ) {
        self.authState = authState
        _isDarkTheme = isDarkTheme
        self.onAuthEvent = onAuthEvent
        self.productState = productState
        self.onProductEvent = onProductEvent
        self.onPocketGoodsAppEvent = onPocketGoodsAppEvent
        _loginFormState = loginFormState
        self.onLoginEvent = onLoginEvent
        _registerFormState = registerFormState
        self.onRegisterEvent = onRegisterEvent
        _searchQuery = searchQuery
        self.userHasLoggedInEvent = userHasLoggedInEvent
        self.typingText = typingText
    }

    var body: some View {
        GeometryReader { reader in
            Header(
                onLogoClick: {
                    router.navigate(
                        to: .HomeScreen,
                        onNavigate: { destination in
                            if let destination {
                                onPocketGoodsAppEvent(
                                    .onSetCurrentDestination(
                                        destination: destination
                                    )
                                )
                            }
                        }
                    )
                },
                searchInput: {
                    SearchInput(
                        query: $searchQuery,
                        searchLabel: LocalKeys.search.localized(
                            bundle: .coreUIBundle
                        ),
                        search: {
                            router.navigate(
                                to: .ProductSearchResultScreen,
                                onNavigate: { destination in
                                    if let destination {
                                        onPocketGoodsAppEvent(
                                            .onSetCurrentDestination(
                                                destination: destination
                                            )
                                        )
                                    }
                                }
                            )
                        },
                        clearQuery: {
                            onProductEvent(.clearSearch)
                        },
                        onSuggestedProductClick: { productId in
                            router.navigate(
                                to: .ProductDetailScreen(productId: productId),
                                onNavigate: { destination in
                                    if let destination {
                                        onPocketGoodsAppEvent(
                                            .onSetCurrentDestination(
                                                destination: destination
                                            )
                                        )
                                    }
                                }
                            )
                        },
                        suggestedProducts: productState.suggestedProducts,
                        textFieldWidth: reader.size.width * 0.45,
                        autoCompleteWidth: reader.size.width * 0.55,
                        autoCompleteHeight: reader.size.height * 0.5
                    )
                },
                toolbar: {
                    Toolbar(
                        isDarkTheme: $isDarkTheme,
                        authState: authState,
                        formType: $formType,
                        loginState: $loginFormState,
                        userHasLoggedInEvent:
                            userHasLoggedInEvent,
                        onLoginFormEvent: onLoginEvent,
                        registerState: $registerFormState,
                        onRegisterFormEvent: onRegisterEvent,
                        onLogout: {
                            if let authenticatedUser = authState
                                .authenticatedUser
                            {
                                onAuthEvent(
                                    .onLogout(
                                        userId: authenticatedUser.id,
                                        onLoggedOut: {
                                            onAuthEvent(
                                                .setAuthenticatedUser(user: nil)
                                            )
                                            snackbarController.show(
                                                message: LocalKeys
                                                    .loggedOut
                                                    .localized(
                                                        bundle: .coreUIBundle
                                                    ),
                                                severity: .success
                                            )
                                        },
                                        onError: {
                                            snackbarController.show(
                                                message: LocalKeys
                                                    .loggedOutError
                                                    .localized(
                                                        bundle: .coreUIBundle
                                                    ),
                                                severity: .error
                                            )
                                        }
                                    )
                                )
                            }
                        },
                        onLoggedIn: { user in
                            onLoginEvent(.setAlert(message: "", visible: false))
                            modalController.dismiss()
                            snackbarController.show(
                                message: LocalKeys
                                    .loggedIn
                                    .localized(
                                        bundle: .coreUIBundle,
                                        user.name
                                    ),
                                severity: .success
                            )
                        },
                        onUserMenuClick: {
                            onAuthEvent(
                                .onRefreshUserData(
                                    onRefreshFailed: {
                                        snackbarController.show(
                                            message: LocalKeys
                                                .refreshUserDataError
                                                .localized(
                                                    bundle: .coreUIBundle
                                                ),
                                            severity: .error
                                        )
                                    }
                                )
                            )
                        },
                        onWishlistManagerClick: {
                            if authState.authenticatedUser != nil {
                                router.navigate(
                                    to: .WishlistManagerScreen,
                                    onNavigate: { destination in
                                        if let destination {
                                            onPocketGoodsAppEvent(
                                                .onSetCurrentDestination(
                                                    destination: destination
                                                )
                                            )
                                        }
                                    }
                                )
                            } else {
                                router.navigate(
                                    to: .UnAuthorizedScreen,
                                    onNavigate: { destination in
                                        if let destination {
                                            onPocketGoodsAppEvent(
                                                .onSetCurrentDestination(
                                                    destination: destination
                                                )
                                            )
                                        }
                                    }
                                )
                            }
                        },
                        onDarkThemeSwitched: { isDarkTheme in
                            onPocketGoodsAppEvent(
                                .onSetDarkTheme(isDarkTheme: isDarkTheme)
                            )
                        }
                    )
                    .padding(.top, 12)
                },
                typingText: typingText
            )
        }
    }
}

private struct HeaderSectionPreview: View {

    @State
    private var authState = AuthState(
        authenticatedUser: MockData.userDTO.toUser()
    )

    @State
    private var productState: ProductState = .init()

    @State
    private var pocketGoodsState: PocketGoodsAppState = .init()

    @State
    private var searchQuery: String = ""

    @State
    public var loginFormState: LoginFormState = LoginFormState()

    @State
    private var registerState: RegisterFormState = RegisterFormState()

    private let userHasLoggedInEvent = PassthroughSubject<User, Never>()

    @StateObject
    private var router = Router()

    @StateObject
    private var snackbarController = SnackbarController()

    @StateObject
    private var modalController = ModalController()

    var body: some View {
        VStack {
            HeaderSection(
                authState: authState,
                onAuthEvent: { event in
                    switch event {
                    case .onRefreshUserData(_):
                        authState = authState.copy(
                            authenticatedUser: MockData.userDTO.toUser()
                        )

                    case .setAuthenticatedUser(let user):
                        authState = authState.copy(
                            authenticatedUser: .some(user)
                        )

                    case .onLogout(_, _, _):
                        authState = authState.copy(
                            authenticatedUser: .some(nil)
                        )
                    }
                },
                productState: productState,
                onProductEvent: { event in
                    switch event {
                    case .clearSearch:
                        productState = productState.copy(
                            suggestedProducts: []
                        )

                    case .getProducts:
                        productState = productState.copy(
                            isPageLoading: true
                        )
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 2
                        ) {
                            productState = productState.copy(
                                products: MockData
                                    .productsPaginationResponse
                                    .data
                                    .map({ $0.toProductPreview() }),
                                isPageLoading: false
                            )
                        }

                    case .loadProduct(_):
                        productState = productState.copy(
                            isPageLoading: true
                        )

                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 2
                        ) {
                            productState = productState.copy(
                                isPageLoading: false,
                                product: MockData
                                    .sunGlassesProductResponse
                                    .data
                            )
                        }

                    case .searchSuggestions:
                        productState = productState.copy(
                            isSearching: true
                        )
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 0.5
                        ) {
                            let suggestions =
                                MockData
                                .suggestedProducts(query: searchQuery)
                                .data
                                .map({ $0.toProductPreview() })

                            productState = productState.copy(
                                isSearching: false,
                                suggestedProducts: suggestions
                            )
                        }

                    default:
                        break
                    }
                },
                onPocketGoodsAppEvent: { event in
                    switch event {
                    case .onSetDarkTheme(let isDarkTheme):
                        pocketGoodsState = pocketGoodsState.copy(
                            isDarkTheme: isDarkTheme
                        )
                    default:
                        break
                    }
                },
                loginFormState: $loginFormState,
                onLoginEvent: { event in
                    switch event {
                    case .togglePasswordVisible:
                        loginFormState = loginFormState.copy(
                            isPasswordVisible: !loginFormState
                                .isPasswordVisible
                        )
                    case .setAlert(let message, let visible):
                        loginFormState = loginFormState.copy(
                            alertText: message,
                            alertVisible: visible
                        )
                    case .login(let onError):
                        loginFormState = loginFormState.copy(
                            shouldValidate: true
                        )

                        if !loginFormState.hasEmailError
                            && !loginFormState.hasPasswordError
                        {
                            loginFormState = loginFormState.copy(
                                isLoading: true
                            )
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 2
                            ) {
                                if loginFormState.email
                                    != MockData.correctEmail
                                {
                                    onError(
                                        ApiError.requestFailed(
                                            NSError(
                                                domain: "unAuthorized",
                                                code: 1
                                            )
                                        )
                                    )
                                    loginFormState = loginFormState.copy(
                                        isLoading: false
                                    )
                                } else {
                                    print(
                                        "login with email: \(loginFormState.email)"
                                    )
                                }
                            }
                        }
                    }
                },
                registerFormState: $registerState,
                onRegisterEvent: { event in
                    switch event {

                    case .togglePasswordVisible:
                        registerState = registerState.copy(
                            isPasswordVisible: !registerState
                                .isPasswordVisible
                        )
                    case .toggleConfirmPasswordVisible:
                        registerState = registerState.copy(
                            isConfirmPasswordVisible: !registerState
                                .isConfirmPasswordVisible
                        )
                    case .setAlert(
                        let message,
                        let visible,
                        let alertType
                    ):
                        registerState = registerState.copy(
                            alertText: message,
                            alertVisible: visible,
                            alertType: alertType
                        )
                    case .register(let onRegistered, let onError):
                        registerState = registerState.copy(
                            shouldValidate: true
                        )

                        if !registerState.hasUsernameError
                            && !registerState.hasEmailError
                            && !registerState.hasPasswordError
                            && !registerState.hasConfirmPasswordError
                        {
                            registerState = registerState.copy(
                                isLoading: true
                            )
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 2
                            ) {
                                if registerState.email
                                    == MockData.correctEmail
                                {
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
                isDarkTheme: Binding(
                    get: { pocketGoodsState.isDarkTheme },
                    set: { value in
                        pocketGoodsState = pocketGoodsState.copy(
                            isDarkTheme: value
                        )
                    }
                ),
                searchQuery: $searchQuery,
                userHasLoggedInEvent: userHasLoggedInEvent,
                typingText: LocalKeys.headerText.localized(
                    bundle: .coreUIBundle
                )
            )
            .frame(height: 400)

            Text("Welcome")

            Spacer()

            Footer(footerHeight: 80)
        }
        .ignoresSafeArea()
        .background(Color.theme().background)
        .modalHost()
        .environmentObject(router)
        .environmentObject(snackbarController)
        .environmentObject(modalController)
    }
}

#Preview {
    HeaderSectionPreview()
}
