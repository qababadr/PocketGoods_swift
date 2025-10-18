//
//  UserMenu.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-09.
//

import CoreUI
import SwiftUI

public enum UserMenuAnchorPosition {
    case LEFT, RIGHT
}

public struct UserMenu: View {

    private let onLogout: () -> Void
    private let onClick: () -> Void
    private let onWishlistManagerClick: () -> Void
    private let onDarkThemeSwitched: (Bool) -> Void
    private let initials: String
    private let wishlistCount: Int
    private let anchorPosition: UserMenuAnchorPosition

    @Binding
    private var isDarkTheme: Bool

    @State
    private var isMenuExpanded: Bool = false

    public init(
        onLogout: @escaping () -> Void,
        onClick: @escaping () -> Void,
        onWishlistManagerClick: @escaping () -> Void,
        onDarkThemeSwitched: @escaping (Bool) -> Void,
        initials: String,
        wishlistCount: Int,
        isDarkTheme: Binding<Bool>,
        anchorPosition: UserMenuAnchorPosition = .LEFT
    ) {
        self.onLogout = onLogout
        self.onClick = onClick
        self.onWishlistManagerClick = onWishlistManagerClick
        self.onDarkThemeSwitched = onDarkThemeSwitched
        self.initials = initials
        self.wishlistCount = wishlistCount
        _isDarkTheme = isDarkTheme
        self.anchorPosition = anchorPosition
    }

    public var body: some View {
        Button(
            action: {
                onClick()
                withAnimation {
                    isMenuExpanded.toggle()
                }
            }
        ) {
            Text(initials)
                .font(.bodyMedium)
                .foregroundColor(.theme().onPrimary)
                .padding(8)
                .background(Color.theme().primary)
                .clipShape(Circle())
                .shadow(radius: Theme.medium)
        }
        .accessibilityIdentifier(LocalKeys.toolbarUserMenuCd)
        .overlay {
            VStack(alignment: .leading, spacing: 12) {
                Button(action: {
                    withAnimation {
                        isMenuExpanded.toggle()
                    }
                    onWishlistManagerClick()
                }) {
                    HStack(spacing: 4) {
                        Image("book-heart", bundle: .coreUIBundle)
                            .resizable()
                            .scaledToFit()
                            .tint(.theme().onBackground)
                            .frame(width: 26, height: 26)

                        Text(
                            LocalKeys.myWishlist.localized(
                                bundle: .coreUIBundle
                            )
                        )
                        .font(.bodyMedium)
                        .foregroundColor(.theme().onBackground)

                        Spacer()

                        Text(wishlistCount.description)
                            .font(.bodyMedium)
                            .foregroundColor(.theme().onPrimary)
                            .padding(8)
                            .background(Color.theme().error)
                            .clipShape(Circle())
                    }
                }
                .accessibilityIdentifier(LocalKeys.myWishlist)

                HStack(spacing: 4) {
                    Image("palette", bundle: .coreUIBundle)
                        .resizable()
                        .scaledToFit()
                        .tint(.theme().onBackground)
                        .frame(width: 26, height: 26)

                    Text(
                        LocalKeys.switchTheme.localized(
                            bundle: .coreUIBundle
                        )
                    )
                    .font(.bodyMedium)
                    .foregroundColor(.theme().onBackground)

                    Spacer()

                    ThemeSwitch(isDarkTheme: $isDarkTheme)
                        .onChange(of: isDarkTheme) { _ in
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 0.3
                            ) {
                                withAnimation {
                                    isMenuExpanded = false
                                }

                            }
                        }
                }

                Divider()

                Button(action: {
                    onLogout()
                    withAnimation {
                        isMenuExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image("logout-variant", bundle: .coreUIBundle)
                            .resizable()
                            .scaledToFit()
                            .tint(.theme().onBackground)
                            .frame(width: 26, height: 26)

                        Text(
                            LocalKeys.logout.localized(
                                bundle: .coreUIBundle
                            )
                        )
                        .font(.bodyMedium)
                        .foregroundColor(.theme().onBackground)

                        Spacer()
                    }
                }
                .accessibilityIdentifier(LocalKeys.logout)
            }
            .padding(.all, 8)
            .background(Color.theme().background)
            .cornerRadius(Theme.medium)
            .shadow(radius: 4)
            .frame(width: isMenuExpanded ? 250 : 20)
            .opacity(isMenuExpanded ? 1 : 0)
            .offset(
                x: anchorPosition == .LEFT ? -110 : 45,
                y: isMenuExpanded ? 90 : 0
            )
        }
    }
}

private struct UserMenuPreview: View {
    @State
    private var isDarkTheme: Bool = false

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                HStack {
                    Spacer()
                    UserMenu(
                        onLogout: {},
                        onClick: {},
                        onWishlistManagerClick: {},
                        onDarkThemeSwitched: { isDarkTheme in
                            self.isDarkTheme = isDarkTheme
                        },
                        initials: "AB",
                        wishlistCount: 2,
                        isDarkTheme: $isDarkTheme
                    )
                    .padding(.trailing)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    UserMenuPreview()
}
