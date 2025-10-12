//
//  ApplicationSettingsRepository.swift
//  SettingsFeature
//
//  Created by BADR  QABA on 2025-10-12.
//

import Combine
import CoreApp

public protocol ApplicationSettingsRepository {
    func getApplicationSettings() throws -> AnyPublisher<
        AppSettings?, ApiError
    >

    func saveApplicationSettings(settings: AppSettings) throws
}
