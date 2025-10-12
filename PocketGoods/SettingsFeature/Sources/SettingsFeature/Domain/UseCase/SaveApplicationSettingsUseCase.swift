//
//  SaveApplicationSettingsUseCase.swift
//  SettingsFeature
//
//  Created by BADR  QABA on 2025-10-12.
//

import CoreApp
import Foundation

public final class SaveApplicationSettingsUseCase {

    private let repository: ApplicationSettingsRepository?

    public init(repository: ApplicationSettingsRepository?) {
        self.repository = repository
    }

    public func callAsFunction(settings: AppSettings) throws {
        guard let repository else { throw ApiError.missingDependencies }
        try repository.saveApplicationSettings(settings: settings)
    }
}
