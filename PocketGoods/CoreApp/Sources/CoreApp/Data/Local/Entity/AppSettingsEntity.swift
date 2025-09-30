//
//  AppSettingsEntity.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import GRDB

public struct AppSettingsEntity:
    Sendable,
    FetchableRecord,
    PersistableRecord,
    Codable,
    Identifiable
{
    public var id: Int64
    public var isDarkMode: Bool
    public var latestRoute: String?

    public init(id: Int64, isDarkMode: Bool, latestRoute: String? = nil) {
        self.id = id
        self.isDarkMode = isDarkMode
        self.latestRoute = latestRoute
    }

    public static var databaseTableName: String {
        Constant.APP_SETTINGS_TABLE
    }

    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let isDarkMode = Column(CodingKeys.isDarkMode)
        static let latestRoute = Column(CodingKeys.latestRoute)
    }

    mutating public func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case isDarkMode = "is_dark_mode"
        case latestRoute = "latest_route"
    }
}
