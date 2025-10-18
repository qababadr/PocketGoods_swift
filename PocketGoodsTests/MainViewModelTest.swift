//
//  MainViewModelTest.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//

import Combine
import CoreApp
import Foundation
import XCTest

@testable import AuthenticationFeature
@testable import PocketGoods
@testable import SettingsFeature
@testable import WishlistFeature

final class MainViewModelTest: XCTestCase {
    private var memoryDatabase: PocketGoodsDatabaseManager?
    private var mockCryptoService: CryptoService?
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: MainViewModel?

    override func setUpWithError() throws {
        try super.setUpWithError()

        memoryDatabase = PocketGoodsDatabaseBuilder()
            .eraseDatabaseOnSchemaChange(true)
            .inMemory(true)
            .migrationVersion("v1")
            .build()

        mockCryptoService = MockCryptoService()
    }

    @MainActor
    func test_mainViewModel_can_stream_app_settings() async throws {

        setupViewModel()

        guard let viewModel
        else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description: "Should stream app settings"
        )

        viewModel
            .$state
            .sink { state in
                XCTAssertFalse(state.isDarkTheme)

                if state.latestVisitedScreen == .WishlistManagerScreen {
                    expectation.fulfill()
                }

            }
            .store(in: &cancellables)

        viewModel.onEvent(
            event: .onSetCurrentDestination(destination: .WishlistManagerScreen)
        )

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    @MainActor
    private func setupViewModel() {
        let apiService = ApiServiceBuilder()
            .timeout(timeout: Constant.REQUEST_TIMEOUT)
            .session(session: MockURLProtocol.makeSession())
            .baseUrl(stringUrl: Constant.API_BASE_URL)
            .withLogger()
            .build()

        let authRepository = AuthenticationRepositoryImpl(
            apiService: apiService,
            database: memoryDatabase,
            cryptoService: mockCryptoService
        )

        let settingsRepository = ApplicationSettingsRepositoryImpl(
            database: memoryDatabase
        )

        let wishlistRepository = WishlistRepositoryImpl(
            apiService: apiService,
            database: memoryDatabase,
            cryptoService: mockCryptoService
        )

        let authUseCases = AuthenticationUseCases(
            login: LoginUseCase(repository: authRepository),
            register: RegisterUseCase(repository: authRepository),
            logout: LogoutUseCase(repository: authRepository),
            clearCachedUser: ClearCachedUserUseCase(repository: authRepository),
            getAuthenticatedUser: GetAuthenticatedUserUseCase(
                repository: authRepository
            ),
            getCachedAuthenticatedUser: GetCachedAuthenticatedUserUseCase(
                repository: authRepository
            )
        )

        let settingsUseCases = ApplicationSettingsUseCases(
            getApplicationSettings: GetApplicationSettingsUseCase(
                repository: settingsRepository
            ),
            saveApplicationSettings: SaveApplicationSettingsUseCase(
                repository: settingsRepository
            )
        )

        let wishlistUseCases = WishlistUseCases(
            getEntireWishlist: GetEntireWishlistUseCase(
                repository: wishlistRepository
            ),
            toggleWishlist: ToggleWishlistUseCase(
                repository: wishlistRepository
            )
        )

        viewModel = MainViewModel(
            authUseCases: authUseCases,
            settingsUseCases: settingsUseCases,
            wishlistUseCases: wishlistUseCases
        )
    }
}
