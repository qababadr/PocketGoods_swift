//
//  PocketGoodsApp.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-09-27.
//

import AuthenticationFeature
import CoreApp
import CoreUI
import ProductFeature
import SettingsFeature
import SwiftUI
import WishlistFeature

@main
struct PocketGoodsApp: App {

    @StateObject
    private var productViewModel: ProductViewModel

    @StateObject
    private var authViewModel: AuthViewModel

    @StateObject
    private var wishlistViewModel: WishlistManagerViewModel

    @StateObject
    private var mainViewModel: MainViewModel

    @StateObject
    private var router: Router = Router()

    @StateObject
    private var snackbarController: SnackbarController = SnackbarController()

    @StateObject
    private var modalController: ModalController = ModalController()

    init() {
        LatoFont.registerFonts()

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(.theme().onPrimary)
        ]

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(.theme().onPrimary)
        ]

        UINavigationBar.appearance().tintColor = UIColor(.theme().primary)

        UINavigationBar.appearance().isTranslucent = true

        UITableView.appearance().backgroundColor = UIColor.clear

        AppDependency
            .shared
            .installDependencies()

        @Inject
        var productUseCases: ProductUseCases

        @Inject
        var wishlistUseCases: WishlistUseCases

        @Inject
        var authUseCases: AuthenticationUseCases

        @Inject
        var settingsUseCases: ApplicationSettingsUseCases

        _productViewModel = StateObject(
            wrappedValue: ProductViewModel(useCases: productUseCases)
        )

        _wishlistViewModel = StateObject(
            wrappedValue: WishlistManagerViewModel(useCases: wishlistUseCases)
        )

        _authViewModel = StateObject(
            wrappedValue: AuthViewModel(useCases: authUseCases)
        )

        _mainViewModel = StateObject(
            wrappedValue: MainViewModel(
                authUseCases: authUseCases,
                settingsUseCases: settingsUseCases,
                wishlistUseCases: wishlistUseCases
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if mainViewModel.state.isSplashScreenVisible {
                    SpalshScreen()
                        .transition(.move(edge: .leading))
                } else {
                    Layout(
                        authState: authViewModel.authState,
                        onAuthEvent: authViewModel.onAuthEvent(event:),
                        pocketGoodsAppState: $mainViewModel.state,
                        onPocketGoodsAppEvent: mainViewModel.onEvent(event:),
                        loginFormState: $authViewModel.loginFormState,
                        onLoginEvent: authViewModel.onLoginFormEvent(event:),
                        registerFormState: $authViewModel.registerFormState,
                        onRegisterEvent: authViewModel.onRegisterFormEvent(
                            event:
                        ),
                        productState: productViewModel.state,
                        onProductEvent: productViewModel.onEvent(event:),
                        searchQuery: $productViewModel.searchQuery,
                        userHasLoggedInEvent: authViewModel.loginSuccessSubject,
                        wishlistManagerState: $wishlistViewModel.state,
                        onWishlistManagerScreenEvent: wishlistViewModel.onEvent(
                            event:
                        )
                    )
                    .snackbarHost(
                        data: $snackbarController.data,
                        cornerRadius: Theme.medium,
                        font: .bodyMedium,
                        onClose: {
                            snackbarController.dismiss()
                        }
                    )
                    .modalHost()
                    .onAppear {
                        let destination = mainViewModel.state
                            .latestVisitedScreen

                        if destination.isPrivateDestination
                            && authViewModel.authState.authenticatedUser == nil
                        {
                            router.navigate(to: .UnAuthorizedScreen)
                        } else {
                            router.navigate(to: destination)
                        }
                    }
                    .onChange(of: mainViewModel.state.latestVisitedScreen) {
                        _,
                        destination in
                        if destination.isPrivateDestination {
                            mainViewModel.onEvent(
                                event: .authCheck(
                                    onUnAuthenticated: {
                                        authViewModel.onAuthEvent(
                                            event: .setAuthenticatedUser(
                                                user: nil
                                            )
                                        )
                                        router.navigate(to: .UnAuthorizedScreen)
                                    }
                                )
                            )
                        }
                    }
                }
            }
            .preferredColorScheme(
                mainViewModel.state.isDarkTheme ? .dark : .light
            )
            .onAppear {
                mainViewModel.onEvent(
                    event: .onLoadData(
                        onSuccess: { user in
                            if let user {
                                authViewModel.onAuthEvent(
                                    event: .setAuthenticatedUser(
                                        user: user
                                    )
                                )
                            }
                        },
                        onError: {
                            authViewModel.onAuthEvent(
                                event: .setAuthenticatedUser(
                                    user: nil
                                )
                            )
                        }
                    )
                )
            }
            .environmentObject(mainViewModel)
            .environmentObject(productViewModel)
            .environmentObject(authViewModel)
            .environmentObject(wishlistViewModel)
            .environmentObject(snackbarController)
            .environmentObject(router)
            .environmentObject(modalController)
        }
    }
}
