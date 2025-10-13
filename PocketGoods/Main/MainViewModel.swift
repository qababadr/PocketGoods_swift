//
//  MainViewModel.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-12.
//

import AuthenticationFeature
import Combine
import CoreApp
import CoreUI
import Foundation
import SettingsFeature
import WishlistFeature

@MainActor
class MainViewModel: ObservableObject {

    @Published
    var state: PocketGoodsAppState = .init()

    private let authUseCases: AuthenticationUseCases?
    private let settingsUseCases: ApplicationSettingsUseCases?
    private let wishlistUseCases: WishlistUseCases?

    private var cancellables: Set<AnyCancellable> = []

    init(
        authUseCases: AuthenticationUseCases?,
        settingsUseCases: ApplicationSettingsUseCases?,
        wishlistUseCases: WishlistUseCases?
    ) {
        self.authUseCases = authUseCases
        self.settingsUseCases = settingsUseCases
        self.wishlistUseCases = wishlistUseCases

        streamAppSettings()
    }

    func onEvent(event: PocketGoodsAppEvent) {
        switch event {

        case .onLoadData(let onSuccess, let onError):
            onLoadData(onSuccess: onSuccess, onError: onError)

        case .onSetDarkTheme(let isDarkTheme):
            onSetDarkTheme(isDarkTheme: isDarkTheme)

        case .onToggleWishlist(
            let userId,
            let productId,
            let onAdded,
            let onRemoved
        ):
            onToggleWishlist(
                userId: userId,
                productId: productId,
                onAdded: onAdded,
                onRemoved: onRemoved
            )

        case .onSetCurrentDestination(let destination):
            onSetCurrentDestination(destination: destination)

        case .authCheck(let onUnAuthenticated):
            authCheck(onUnAuthenticated: onUnAuthenticated)
        }
    }

    private func onSetCurrentDestination(destination: Destination) {
        guard let settingsUseCases else { return }
        state = state.copy(
            latestVisitedScreen: destination
        )

        try? settingsUseCases.saveApplicationSettings(
            settings: AppSettings(
                isDarkMode: state.isDarkTheme,
                latestRoute: destination.rawValue
            )
        )
    }

    private func authCheck(onUnAuthenticated: @escaping () -> Void) {
        guard let authUseCases else { return }
        Task {
            await authUseCases
                .getAuthenticatedUser()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(_) = completion {
                        Task {
                            await authUseCases.clearCachedUser()
                            onUnAuthenticated()
                        }
                    }
                } receiveValue: { resource in
                    if case .error(data: _, error: _) = resource {
                        Task {
                            await authUseCases.clearCachedUser()
                            onUnAuthenticated()
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }

    private func onLoadData(
        onSuccess: @escaping (User?) -> Void,
        onError: @escaping () -> Void
    ) {
        guard let authUseCases else { return }

        state = state.copy(
            isSplashScreenVisible: true
        )

        Task {
            await authUseCases
                .getAuthenticatedUser()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    if case .failure(_) = completion {
                        Task {
                            await authUseCases.clearCachedUser()
                            onError()
                            self.state = self.state.copy(
                                isSplashScreenVisible: false
                            )
                        }
                    }
                } receiveValue: { [weak self] resource in
                    guard let self else { return }
                    switch resource {
                    case .success(let user):
                        onSuccess(user)
                        state = state.copy(
                            isSplashScreenVisible: false
                        )

                    case .error(data: _, error: _):
                        Task {
                            await authUseCases.clearCachedUser()
                            onError()
                            self.state = self.state.copy(
                                isSplashScreenVisible: false
                            )
                        }

                    default:
                        break
                    }
                }
                .store(in: &cancellables)

        }
    }

    private func onSetDarkTheme(isDarkTheme: Bool) {
        guard let settingsUseCases else { return }
        try? settingsUseCases.saveApplicationSettings(
            settings: AppSettings(isDarkMode: isDarkTheme)
        )
    }

    private func onToggleWishlist(
        userId: Int64,
        productId: Int64,
        onAdded: @escaping () -> Void,
        onRemoved: @escaping () -> Void
    ) {
        guard let wishlistUseCases else { return }

        Task {
            if let insertedWishlistItemId =
                try? await wishlistUseCases.toggleWishlist(
                    userId: userId,
                    productId: productId
                )
            {
                switch insertedWishlistItemId {
                case -1:
                    onRemoved()
                default:
                    onAdded()
                }
            }
        }
    }

    private func streamAppSettings() {
        guard let settingsUseCases else { return }

        try? settingsUseCases
            .getApplicationSettings()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case .failure(_) = completion {
                        state = state.copy(
                            isDarkTheme: false,
                            latestVisitedScreen: .HomeScreen
                        )
                    }
                },
                receiveValue: { [weak self] appSettings in
                    guard let self else { return }
                    state = state.copy(
                        isDarkTheme: appSettings?.isDarkMode ?? false,
                        latestVisitedScreen: Destination(
                            rawValue: appSettings?.latestRoute
                                ?? Destination.HomeScreen.rawValue
                        )
                    )
                }
            )
            .store(in: &cancellables)
    }
}
