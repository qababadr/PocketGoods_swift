//
//  ApplicationSettingsRepositoryImpl.swift
//  SettingsFeature
//
//  Created by BADR  QABA on 2025-10-12.
//
import Combine
import CoreApp

public final class ApplicationSettingsRepositoryImpl:
    ApplicationSettingsRepository
{

    private let database: PocketGoodsDatabaseManager?

    public init(database: PocketGoodsDatabaseManager?) {
        self.database = database
    }

    public func getApplicationSettings() throws -> AnyPublisher<
        AppSettings?, ApiError
    > {
        guard let database else {
            return Fail(error: ApiError.missingDependencies)
                .eraseToAnyPublisher()
        }

        return
            try database
            .streamApplicationSettings()
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }

    public func saveApplicationSettings(settings: AppSettings) throws {
        guard let database else { return }
        try database.insert(
            settings.toAppSettingsEntity(),
            onConflict: .replace
        )
    }

}
