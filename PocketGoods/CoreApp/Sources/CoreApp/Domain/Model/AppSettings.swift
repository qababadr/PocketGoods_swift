//
//  AppSettings.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

public struct AppSettings: Sendable, Codable {
    public let isDarkMode: Bool
    public let latestRoute: String?

    public init(isDarkMode: Bool, latestRoute: String? = nil) {
        self.isDarkMode = isDarkMode
        self.latestRoute = latestRoute
    }
}
