//
//  PocketGoodsDatabaseBuilder.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

public class PocketGoodsDatabaseBuilder {

    private var databaseName: String = ""
    private var databaseExtension: String = ""
    private var eraseDatabaseOnSchemaChange: Bool = true
    private var inMemory: Bool = false
    private var cacheFolderName: String = ""
    private var migrationVersion: String = "v1"

    public init() {}

    public func databaseName(_ name: String) -> PocketGoodsDatabaseBuilder {
        databaseName = name
        return self
    }

    public func databaseExtension(_ ext: String) -> PocketGoodsDatabaseBuilder {
        databaseExtension = ext
        return self
    }

    public func eraseDatabaseOnSchemaChange(_ value: Bool)
        -> PocketGoodsDatabaseBuilder
    {
        eraseDatabaseOnSchemaChange = value
        return self
    }

    public func inMemory(_ value: Bool) -> PocketGoodsDatabaseBuilder {
        inMemory = value
        return self
    }

    public func cacheFolderName(_ value: String) -> PocketGoodsDatabaseBuilder {
        self.cacheFolderName = value
        return self
    }

    public func migrationVersion(_ value: String) -> PocketGoodsDatabaseBuilder
    {
        migrationVersion = value
        return self
    }

    public func build() -> PocketGoodsDatabaseManager {
        return PocketGoodsDatabaseManager(
            databaseName: databaseName,
            databaseExtension: databaseExtension,
            eraseDatabaseOnSchemaChange: eraseDatabaseOnSchemaChange,
            placementFolder: cacheFolderName,
            migrationVersion: migrationVersion,
            inMemory: inMemory,
            
        )
    }
}
