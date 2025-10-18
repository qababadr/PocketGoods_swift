//
//  Layout.swift
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
import WishlistFeature

struct Layout: View {
    let authState: AuthState
    let onAuthEvent: (AuthEvent) -> Void

    @Binding
    var loginFormState: LoginFormState
    let onLoginEvent: (LoginFormEvent) -> Void

    @Binding
    var pocketGoodsAppState: PocketGoodsAppState
    let onPocketGoodsAppEvent: (PocketGoodsAppEvent) -> Void

    @Binding
    var registerFormState: RegisterFormState
    let onRegisterEvent: (RegisterFormEvent) -> Void

    let productState: ProductState
    let onProductEvent: (ProductEvent) -> Void

    let userHasLoggedInEvent: PassthroughSubject<User, Never>

    @Binding
    var wishlistManagerState: WishlistManagerState
    let onWishlistManagerScreenEvent: (WishlistManagerScreenEvent) -> Void

    @Binding
    private var searchQuery: String

    @EnvironmentObject
    var router: Router

    init(
        authState: AuthState,
        onAuthEvent: @escaping (AuthEvent) -> Void,
        pocketGoodsAppState: Binding<PocketGoodsAppState>,
        onPocketGoodsAppEvent: @escaping (PocketGoodsAppEvent) -> Void,
        loginFormState: Binding<LoginFormState>,
        onLoginEvent: @escaping (LoginFormEvent) -> Void,
        registerFormState: Binding<RegisterFormState>,
        onRegisterEvent: @escaping (RegisterFormEvent) -> Void,
        productState: ProductState,
        onProductEvent: @escaping (ProductEvent) -> Void,
        searchQuery: Binding<String>,
        userHasLoggedInEvent: PassthroughSubject<User, Never>,
        wishlistManagerState: Binding<WishlistManagerState>,
        onWishlistManagerScreenEvent: @escaping (WishlistManagerScreenEvent) ->
            Void
    ) {
        self.authState = authState
        self.onAuthEvent = onAuthEvent
        _pocketGoodsAppState = pocketGoodsAppState
        self.onPocketGoodsAppEvent = onPocketGoodsAppEvent
        _loginFormState = loginFormState
        self.onLoginEvent = onLoginEvent
        _registerFormState = registerFormState
        self.onRegisterEvent = onRegisterEvent
        self.productState = productState
        self.onProductEvent = onProductEvent
        _searchQuery = searchQuery
        self.userHasLoggedInEvent = userHasLoggedInEvent
        _wishlistManagerState = wishlistManagerState
        self.onWishlistManagerScreenEvent = onWishlistManagerScreenEvent
    }

    var body: some View {
        Navigation(
            path: $router.navigationStack,
            root: .HomeScreen,
            header: {
                HeaderSection(
                    authState: authState,
                    onAuthEvent: onAuthEvent,
                    productState: productState,
                    onProductEvent: onProductEvent,
                    onPocketGoodsAppEvent: onPocketGoodsAppEvent,
                    loginFormState: $loginFormState,
                    onLoginEvent: onLoginEvent,
                    registerFormState: $registerFormState,
                    onRegisterEvent: onRegisterEvent,
                    isDarkTheme: $pocketGoodsAppState.isDarkTheme,
                    searchQuery: $searchQuery,
                    userHasLoggedInEvent:
                        userHasLoggedInEvent,
                    typingText: LocalKeys.headerText.localized(
                        bundle: .coreUIBundle
                    ),
                )
                .frame(height: 420)
            },
            mainContent: { destination in
                buildRoutes(destination: destination)
                    .background(Color.theme().background)
            },
            footer: {
                Footer(
                    footerHeight: 80,
                    accessibilityID: pocketGoodsAppState.isDarkTheme
                        ? UIConstants.parentContainerInDarkTheme
                        : UIConstants.parentContainerInLightTheme
                )
            },
            scrollableID: UIConstants.scrollableContainer
        )
        .mainContentMinHeight(UIScreen.main.bounds.height * 0.45)
    }
}

private enum MockDestination: Codable, Hashable {
    case HomeScreen
    case ProductDetailScreen(productTitle: String)
}

private struct ProductsView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let onItemClick: (String) -> Void

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<200) { index in
                Text("Product \(index)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .onTapGesture {
                        onItemClick("Product \(index)")
                    }
            }
        }
        .padding()
    }
}

private struct ProductsViewDetail: View {

    let productTitle: String

    var body: some View {
        Text("Product \(productTitle)")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
            .padding()
    }
}

private struct MockLayout: View {

    @State
    private var path: [MockDestination] = [.HomeScreen]

    var body: some View {
        Navigation(
            path: $path,
            root: .HomeScreen,
            header: {
                Text("Header")
                    .font(.largeTitle)
                    .padding()
            },
            mainContent: { data in
                switch data {
                case .HomeScreen:
                    ProductsView(
                        onItemClick: { productTitle in
                            path.append(
                                .ProductDetailScreen(productTitle: productTitle)
                            )
                        }
                    )

                case .ProductDetailScreen(let productTitle):
                    ProductsViewDetail(productTitle: productTitle)
                }
            },
            footer: {
                Text("Footer")
                    .font(.largeTitle)
                    .padding()
            }
        )
        .frame(minHeight: UIScreen.main.bounds.height)
    }
}

#Preview {
    MockLayout()
}
