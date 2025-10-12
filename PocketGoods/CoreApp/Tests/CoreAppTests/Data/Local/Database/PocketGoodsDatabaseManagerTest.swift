//
//  PocketGoodsDatabaseManagerTest.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

import Combine
import XCTest

@testable import CoreApp

final class PocketGoodsDatabaseManagerTest: XCTestCase {
    private var memoryDatabase: PocketGoodsDatabaseManager?
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()

        memoryDatabase = PocketGoodsDatabaseBuilder()
            .eraseDatabaseOnSchemaChange(true)
            .inMemory(true)
            .migrationVersion("v1")
            .build()
    }

    override func tearDownWithError() throws {
        memoryDatabase = nil
        try super.tearDownWithError()
    }

    func
        test_PocketGoodsDatabaseBuilder_should_initialize_object_memoryDatabase()
    {
        XCTAssertNotNil(memoryDatabase)
    }

    func test_PocketGoodsDatabase_reader_should_be_not_nil() {
        XCTAssertNotNil(memoryDatabase?.reader)
    }

    func test_PocketGoodsDatabaseManager_writer_should_be_initialized() {
        let writer = memoryDatabase?.writer
        XCTAssertNotNil(
            writer,
            "DatabaseWriter should be initialized"
        )
    }

    func test_PocketGoodsDatabaseManager_should_create_tables() throws {
        guard let writer = memoryDatabase?.writer else {
            XCTFail("Expecting writer to be not nil")
            return
        }

        try writer.read { database in
            try XCTAssertTrue(database.tableExists(Constant.IMAGES_TABLE))
            try XCTAssertTrue(database.tableExists(Constant.PRODUCTS_TABLE))
            try XCTAssertTrue(database.tableExists(Constant.USERS_TABLE))
            try XCTAssertTrue(database.tableExists(Constant.WISHLIST_TABLE))
            try XCTAssertTrue(database.tableExists(Constant.APP_SETTINGS_TABLE))

            let imagesTableColumns = try database.columns(
                in: Constant.IMAGES_TABLE
            )

            let imagesTableColumnsNames = Set(
                imagesTableColumns.map { $0.name }
            )

            let productsTableColumns = try database.columns(
                in: Constant.PRODUCTS_TABLE
            )
            let productsTableColumnsNames = Set(
                productsTableColumns.map({ $0.name })
            )

            let usersTableColumns = try database.columns(
                in: Constant.USERS_TABLE
            )
            let usersTableColumnsNames = Set(usersTableColumns.map({ $0.name }))

            let wishlistTableColumns = try database.columns(
                in: Constant.WISHLIST_TABLE
            )
            let wishlistTableColumnsNames = Set(
                wishlistTableColumns.map({ $0.name })
            )

            let appSettingsTableColumns = try database.columns(
                in: Constant.APP_SETTINGS_TABLE
            )
            let appSettingsTableColumnsNames = Set(
                appSettingsTableColumns.map({ $0.name })
            )

            XCTAssertEqual(
                imagesTableColumnsNames,
                ["preview", "filename", "original", "uuid", "model_id"]
            )

            XCTAssertEqual(
                productsTableColumnsNames,
                ["id", "title", "category", "price", "quantity", "description"]
            )
            XCTAssertEqual(
                usersTableColumnsNames,
                ["id", "name", "email", "email_verified_at"]
            )
            XCTAssertEqual(
                wishlistTableColumnsNames,
                ["id", "product_id", "user_id"]
            )
            XCTAssertEqual(
                appSettingsTableColumnsNames,
                ["id", "is_dark_mode", "latest_route"]
            )
        }
    }

    func test_PocketGoodsDatabaseManager_should_insert_data() async throws {
        guard let memoryDatabase else {
            XCTFail("Expecting memoryDatabase to be not nil")
            return
        }
        let userDTO = MockData.userDTO

        try MockData.seedUserData(memoryDatabase: memoryDatabase)

        let userData: UserWithWishlistAndProductAndImages? =
            try await memoryDatabase.reader.read { db in
                try UserEntity
                    .including(
                        all: UserEntity.wishlist
                            .including(
                                optional: WishlistItemEntity.product
                                    .including(all: ProductEntity.images)
                            )
                    )
                    .filter(id: userDTO.id)
                    .asRequest(of: UserWithWishlistAndProductAndImages.self)
                    .fetchOne(db)
            }

        XCTAssertNotNil(userData)
        XCTAssertEqual(userDTO.id, userData?.user.id)

        XCTAssertEqual(userDTO.wishlist.count, userData?.wishlist.count)

        for itemDTO in userDTO.wishlist {
            guard
                let wishlistItem = userData?
                    .wishlist
                    .first(where: { $0.wishlist.id == itemDTO.id })
            else {
                XCTFail("Wishlist item with id \(itemDTO.id) is not found")
                continue
            }

            XCTAssertEqual(
                itemDTO.productDetail?.id,
                wishlistItem.productWithImages?.product.id
            )

            XCTAssertEqual(
                itemDTO.productDetail?.title,
                wishlistItem.productWithImages?.product.title
            )

            let dtoImages = itemDTO.productDetail?.media.map { $0.original }
            let savedImages = wishlistItem.productWithImages?.images.map {
                $0.original
            }

            XCTAssertEqual(
                dtoImages,
                savedImages,
                "Original Images mismatch for product \(String(describing: itemDTO.productDetail?.id))"
            )
        }
    }

    func test_streamUser_should_stream_user_data() async throws {
        guard let memoryDatabase else {
            XCTFail("Expecting memoryDatabase to be not nil")
            return
        }

        try MockData.seedUserData(memoryDatabase: memoryDatabase)

        var observedUserState: [User?] = []

        let expectation = XCTestExpectation(
            description: "Should stream user details"
        )

        try memoryDatabase
            .streamUser(userId: MockData.userDTO.id)
            .sink { user in
                observedUserState.append(user)

                if user != nil {
                    expectation.fulfill()
                }

            }
            .store(in: &cancellables)

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif

        XCTAssertTrue(!observedUserState.isEmpty)
        if let latestObservedUserState = observedUserState.last {
            XCTAssertEqual(
                latestObservedUserState,
                MockData.userDTO.toUser()
            )
        }
    }
}
