//
//  WishlistManagerViewModelTest.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-12.
//

import Combine
import CoreApp
import XCTest

@testable import WishlistFeature

final class WishlistManagerViewModelTest: XCTestCase {
    private var memoryDatabase: PocketGoodsDatabaseManager?
    private var mockCryptoService: CryptoService?
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: WishlistManagerViewModel?
    private var useCases: WishlistUseCases?
    private let correctWishlist = MockData
        .loginResponse
        .data
        .user
        .wishlist
        .map { $0.toWishlistItem() }

    override func setUpWithError() throws {
        try super.setUpWithError()

        memoryDatabase = PocketGoodsDatabaseBuilder()
            .eraseDatabaseOnSchemaChange(true)
            .inMemory(true)
            .migrationVersion("v1")
            .build()

        mockCryptoService = MockCryptoService()

        let apiService = ApiServiceBuilder()
            .timeout(timeout: Constant.REQUEST_TIMEOUT)
            .session(session: MockURLProtocol.makeSession())
            .baseUrl(stringUrl: Constant.API_BASE_URL)
            .withLogger()
            .build()

        let repository = WishlistRepositoryImpl(
            apiService: apiService,
            database: memoryDatabase,
            cryptoService: mockCryptoService
        )

        useCases = WishlistUseCases(
            getEntireWishlist: GetEntireWishlistUseCase(repository: repository),
            toggleWishlist: ToggleWishlistUseCase(repository: repository)
        )
    }

    @MainActor
    func test_getWishlistItems_should_get_entire_wishlist_for_the_current_user()
        async throws
    {
        viewModel = WishlistManagerViewModel(useCases: useCases)

        guard let viewModel,
            let memoryDatabase,
            let mockCryptoService
        else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description: "Should get entire wishlist for the current user"
        )

        try MockData.seedUserData(memoryDatabase: memoryDatabase)
        mockCryptoService.saveTokenToKeychain(token: MockData.token)

        viewModel
            .$state
            .dropFirst()
            .sink { state in
                Task {
                    switch state.isPageLoading {
                    case true:
                        XCTAssertTrue(state.wishlist.isEmpty)

                    case false:
                        let cachedUser =
                            try await memoryDatabase.getCachedUserData()

                        XCTAssertNotNil(cachedUser)
                        XCTAssertEqual(state.wishlist, cachedUser?.wishlist)

                        expectation.fulfill()
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.onEvent(event: .getWishlistItems(userId: MockData.userDTO.id))

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }
}
