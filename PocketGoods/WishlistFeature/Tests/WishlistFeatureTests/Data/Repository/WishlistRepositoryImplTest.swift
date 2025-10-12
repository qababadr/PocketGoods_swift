//
//  WishlistRepositoryImplTest.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-10.
//

import Combine
import CoreApp
import XCTest

@testable import WishlistFeature

final class WishlistRepositoryImplTest: XCTestCase {

    private var memoryDatabase: PocketGoodsDatabaseManager?
    private var mockCryptoService: CryptoService?
    private var cancellables = Set<AnyCancellable>()
    private var useCases: WishlistUseCases?

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

    override func tearDownWithError() throws {
        WishlistMockState.currentWishlist =
            MockData
            .userDTO
            .wishlist
    }

    func test_toggleWishlist_should_remove_product_from_user_wishlist()
        async throws
    {
        let productId = MockData
            .sunGlassesProductResponse
            .data
            .id

        guard let memoryDatabase else {
            XCTFail("Missing database instance")
            return
        }

        try MockData.seedUserData(memoryDatabase: memoryDatabase)

        guard let mockCryptoService,
            let cachedUser = try await memoryDatabase.getCachedUserData()
        else {
            XCTFail("Missing dependencies")
            return
        }

        mockCryptoService.saveTokenToKeychain(token: MockData.token)

        guard let useCases else {
            XCTFail("Missing useCases")
            return
        }

        XCTAssertTrue(
            cachedUser.wishlist.contains { $0.productId == productId }
        )

        let response = try await useCases.toggleWishlist(
            userId: cachedUser.id,
            productId: productId
        )

        XCTAssertEqual(response, -1)

        guard
            let newCachedUserData = try await memoryDatabase.getCachedUserData()
        else {
            XCTFail("Expected user data after toggling wishlist, got nil")
            return
        }

        let isInWishlist = newCachedUserData
            .wishlist
            .contains { $0.productId == productId }

        XCTAssertFalse(isInWishlist)
    }

    func test_toggleWishlist_should_add_product_to_user_wishlist()
        async throws
    {
        let productId = MockData
            .sunGlassesProductResponse
            .data
            .id

        guard let memoryDatabase else {
            XCTFail("Missing database instance")
            return
        }

        try MockData.seedUserData(memoryDatabase: memoryDatabase)

        guard let mockCryptoService,
            let cachedUser = try await memoryDatabase.getCachedUserData()
        else {
            XCTFail("Missing dependencies")
            return
        }

        mockCryptoService.saveTokenToKeychain(token: MockData.token)

        guard let useCases else {
            XCTFail("Missing useCases")
            return
        }

        var response = try await useCases.toggleWishlist(
            userId: cachedUser.id,
            productId: productId
        )

        XCTAssertEqual(response, -1)

        guard
            let newCachedUserData = try await memoryDatabase.getCachedUserData()
        else {
            XCTFail("Expected user data after toggling wishlist, got nil")
            return
        }

        XCTAssertFalse(
            newCachedUserData.wishlist.contains { $0.productId == productId }
        )

        response = try await useCases.toggleWishlist(
            userId: cachedUser.id,
            productId: productId
        )

        XCTAssertEqual(response, MockData.insertedWishlistItemId)

        guard
            let finalCachedUserData =
                try await memoryDatabase.getCachedUserData()
        else {
            XCTFail("Expected user data after toggling wishlist, got nil")
            return
        }

        let isInWishlist = finalCachedUserData
            .wishlist
            .contains { $0.productId == productId }

        XCTAssertTrue(isInWishlist)
    }

    func test_toggleWishlist_should_throw_error_when_user_is_not_authenticated()
        async throws
    {
        let productId = MockData
            .productsPaginationResponse
            .data[1]
            .id

        guard let memoryDatabase else {
            XCTFail("Missing database instance")
            return
        }

        try MockData.seedUserData(memoryDatabase: memoryDatabase)

        guard let cachedUser = try await memoryDatabase.getCachedUserData()
        else {
            XCTFail("Missing cached user")
            return
        }

        guard let useCases else {
            XCTFail("Missing useCases")
            return
        }

        do {
            let _ = try await useCases.toggleWishlist(
                userId: cachedUser.id,
                productId: productId
            )
            XCTFail("User was able to toggle wishlist")
        } catch let error as ApiError {
            XCTAssertEqual(error, ApiError.noDataError)
        }
    }

    func
        test_getEntireWishlist_should_get_the_entire_user_wishlist_with_images()
        async throws
    {
        guard let memoryDatabase else {
            XCTFail("Missing database instance")
            return
        }

        try MockData.seedUserData(memoryDatabase: memoryDatabase)

        guard let mockCryptoService,
            let useCases
        else {
            XCTFail("Missing dependencies")
            return
        }

        mockCryptoService.saveTokenToKeychain(token: MockData.token)

        let expectation = XCTestExpectation(
            description: "Should get entire authenticated user wishlist"
        )

        let product = MockData
            .sunGlassesProductResponse
            .data

        await useCases
            .getEntireWishlist()
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    XCTFail(
                        "Expecting authenticated user but got error: \(error)"
                    )
                }
            } receiveValue: { resource in
                switch resource {
                case .loading(let data):
                    XCTAssertNotNil(data)
                    if let data {
                        XCTAssertTrue(!data.isEmpty)
                        data.forEach { item in
                            if item.productId == product.id {
                                XCTAssertNotNil(item.productDetail)
                                XCTAssertTrue(
                                    !item.productDetail!.media.isEmpty
                                )
                            }
                        }
                    }

                case .success(let data):
                    XCTAssertNotNil(data)
                    XCTAssertTrue(!data.isEmpty)
                    data.forEach { item in
                        if item.productId == product.id {
                            XCTAssertNotNil(item.productDetail)
                            XCTAssertTrue(!item.productDetail!.media.isEmpty)
                        }
                    }
                    expectation.fulfill()

                default:
                    break
                }
            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }
}
