//
//  PocketGoodsDatabaseManager.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

import Combine
import Foundation
import GRDB

public class PocketGoodsDatabaseManager {

    public var reader: DatabaseReader {
        writer
    }

    public let writer: DatabaseWriter

    public init(
        databaseName: String,
        databaseExtension: String,
        eraseDatabaseOnSchemaChange: Bool,
        placementFolder: String? = nil,
        migrationVersion: String = "v1",
        inMemory: Bool = false,
    ) {
        var migrator = DatabaseMigrator()

        do {

            if inMemory {
                writer = try DatabaseQueue()
            } else {
                let appSupportDirectory =
                    try FileManager
                    .default
                    .url(
                        for: .applicationSupportDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: true
                    )
                let appDirectory = appSupportDirectory.appendingPathComponent(
                    placementFolder ?? "database_manager_cache"
                )

                if !FileManager.default.fileExists(atPath: appDirectory.path) {
                    try FileManager
                        .default
                        .createDirectory(
                            at: appDirectory,
                            withIntermediateDirectories: true,
                            attributes: nil
                        )
                }

                let databasePath =
                    appDirectory
                    .appendingPathComponent(
                        "\(databaseName).\(databaseExtension)"
                    )
                    .path

                writer = try DatabasePool(path: databasePath)
            }

            #if DEBUG
                migrator.eraseDatabaseOnSchemaChange =
                    eraseDatabaseOnSchemaChange
            #endif

            migrator.registerMigration(migrationVersion) { database in
                try PocketGoodsDatabaseManager.runMigration(database)
            }

            try migrator.migrate(writer)

        } catch {
            fatalError(
                "Error connecting to database: \(String(describing: error))"
            )
        }

    }

    public func insert<T: MutablePersistableRecord & TableRecord>(
        _ entity: T,
        onConflict conflictResolution: Database.ConflictResolution? = nil
    ) throws {
        try writer.write { database in
            var mutableEntity = entity
            try mutableEntity.insert(database, onConflict: conflictResolution)
        }
    }

    public func deleteWhere(
        tableName: String,
        arguments: StatementArguments = StatementArguments()
    ) throws {
        try writer.write { database in
            try database.execute(
                sql: "DELETE FROM \(tableName)",
                arguments: arguments
            )
        }
    }

    public func streamUser(userId: Int64) throws -> AnyPublisher<User?, Never> {
        return
            ValueObservation
            .tracking { database in
                try UserEntity
                    .including(
                        all: UserEntity
                            .wishlist
                            .including(
                                optional:
                                    WishlistItemEntity
                                    .product
                                    .including(all: ProductEntity.images)
                            )
                    )
                    .filter(id: userId)
                    .asRequest(of: UserWithWishlistAndProductAndImages.self)
                    .fetchOne(database)
            }
            .publisher(in: writer)
            .receive(on: DispatchQueue.main)
            .map({ $0?.toUser() })
            .catch { _ in Just(nil) }
            .eraseToAnyPublisher()
    }

    public func streamApplicationSettings() throws -> AnyPublisher<
        AppSettings?, Never
    > {
        return
            ValueObservation
            .tracking { database in
                try AppSettingsEntity
                    .filter(id: 0)
                    .asRequest(of: AppSettingsEntity.self)
                    .fetchOne(database)
            }
            .publisher(in: writer)
            .receive(on: DispatchQueue.main)
            .map({ $0?.toAppSettings() })
            .catch { _ in Just(nil) }
            .eraseToAnyPublisher()
    }

    public func getCachedUserData() async throws -> User? {
        return try await reader.read { db in
            try UserEntity
                .including(
                    all: UserEntity.wishlist
                        .including(
                            optional: WishlistItemEntity.product
                                .including(all: ProductEntity.images)
                        )
                )
                .limit(1)
                .asRequest(of: UserWithWishlistAndProductAndImages.self)
                .fetchOne(db)?
                .toUser()
        }
    }

    private static func runMigration(_ database: Database) throws {
        try PocketGoodsDatabaseManager.imagesTableMigration(database)
        try PocketGoodsDatabaseManager.productsTableMigration(database)
        try PocketGoodsDatabaseManager.usersTableMigration(database)
        try PocketGoodsDatabaseManager.wishlistTableMigration(database)
        try PocketGoodsDatabaseManager.appSettingsTableMigration(database)
    }

    private static func imagesTableMigration(_ database: Database) throws {
        try database.create(
            table: Constant.IMAGES_TABLE
        ) { table in
            table.column("uuid", .text).notNull()
            table.column("filename", .text)
            table.column("preview", .text)
            table.column("original", .text)
            table.primaryKey(["uuid"])
            table.column("model_id", .integer)
                .references(
                    Constant.PRODUCTS_TABLE,
                    column: "id",
                    onDelete: .cascade
                )
        }
    }

    private static func productsTableMigration(_ database: Database) throws {
        try database.create(table: Constant.PRODUCTS_TABLE) { table in
            table.column("id", .integer).notNull().primaryKey()
            table.column("title", .text).notNull()
            table.column("category", .text).notNull()
            table.column("price", .double).notNull()
            table.column("quantity", .integer).notNull()
            table.column("description", .text).notNull()
        }
    }

    private static func usersTableMigration(_ database: Database) throws {
        try database.create(table: Constant.USERS_TABLE) { table in
            table.column("id", .integer).notNull().primaryKey()
            table.column("name", .text).notNull()
            table.column("email", .text).notNull()
            table.column("email_verified_at", .datetime)
        }
    }

    private static func wishlistTableMigration(_ database: Database) throws {
        try database.create(table: Constant.WISHLIST_TABLE) { table in
            table.column("id", .integer).notNull().primaryKey()
            table.column("product_id", .integer)
                .references(
                    Constant.PRODUCTS_TABLE,
                    column: "id",
                )
            table.column("user_id", .integer).notNull()
                .references(
                    Constant.USERS_TABLE,
                    column: "id",
                    onDelete: .cascade
                )
        }
    }

    private static func appSettingsTableMigration(_ database: Database) throws {
        try database.create(table: Constant.APP_SETTINGS_TABLE) { table in
            table.column("id", .integer).notNull().primaryKey()
            table.column("is_dark_mode", .boolean).notNull()
            table.column("latest_route", .text).notNull()
        }
    }
}
