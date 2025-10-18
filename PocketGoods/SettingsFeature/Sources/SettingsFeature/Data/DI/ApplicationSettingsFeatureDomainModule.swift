//
//  ApplicationSettingsFeatureDomainModule.swift
//  SettingsFeature
//
//  Created by BADR  QABA on 2025-10-12.
//

import CoreApp
import Swinject

public struct ApplicationSettingsFeatureDomainModule {
    private init() {}

    @MainActor
    public static func install() {
        AppContainer
            .shared
            .register(ApplicationSettingsRepository.self) {
                ApplicationSettingsFeatureDomainModule
                    .provideApplicationSettingsRepository(
                        resolver: $0
                    )
            }

        AppContainer
            .shared
            .register(ApplicationSettingsUseCases.self) {
                ApplicationSettingsFeatureDomainModule
                    .provideApplicationSettingsUseCases(
                        resolver: $0
                    )
            }
    }

    private static func provideApplicationSettingsRepository(resolver: Resolver)
        -> ApplicationSettingsRepository
    {
        return ApplicationSettingsRepositoryImpl(
            database: resolver.resolve(PocketGoodsDatabaseManager.self)
        )
    }

    private static func provideApplicationSettingsUseCases(resolver: Resolver)
        -> ApplicationSettingsUseCases
    {
        let repository = resolver.resolve(ApplicationSettingsRepository.self)
        return ApplicationSettingsUseCases(
            getApplicationSettings: GetApplicationSettingsUseCase(
                repository: repository
            ),
            saveApplicationSettings: SaveApplicationSettingsUseCase(
                repository: repository
            )
        )
    }
}
