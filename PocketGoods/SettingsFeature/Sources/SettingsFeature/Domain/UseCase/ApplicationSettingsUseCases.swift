//
//  ApplicationSettingsUseCases.swift
//  SettingsFeature
//
//  Created by BADR  QABA on 2025-10-12.
//


public struct ApplicationSettingsUseCases {
    public let getApplicationSettings: GetApplicationSettingsUseCase
    public let saveApplicationSettings: SaveApplicationSettingsUseCase

    public init(
        getApplicationSettings: GetApplicationSettingsUseCase,
        saveApplicationSettings: SaveApplicationSettingsUseCase
    ) {
        self.getApplicationSettings = getApplicationSettings
        self.saveApplicationSettings = saveApplicationSettings
    }
}