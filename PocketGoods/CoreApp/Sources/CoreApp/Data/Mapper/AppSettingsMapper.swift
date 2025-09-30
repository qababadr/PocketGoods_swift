//
//  AppSettingsMapper.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

extension AppSettingsEntity {
    public func toAppSettings() -> AppSettings {
        return AppSettings(
            isDarkMode: isDarkMode,
            latestRoute: latestRoute
        )
    }
}

extension AppSettings {
    public func toAppSettingsEntity() -> AppSettingsEntity {
        return AppSettingsEntity(
            id: 0,
            isDarkMode: isDarkMode,
            latestRoute: latestRoute
        )
    }
}
