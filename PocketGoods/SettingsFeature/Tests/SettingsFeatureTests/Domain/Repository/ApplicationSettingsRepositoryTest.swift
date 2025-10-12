//
//  ApplicationSettingsRepositoryTest.swift
//  SettingsFeature
//
//  Created by BADR  QABA on 2025-10-12.
//

import Combine
import CoreApp
import XCTest

@testable import SettingsFeature

final class ApplicationSettingsRepositoryTest: XCTestCase {
    private var memoryDatabase: PocketGoodsDatabaseManager?
    private var cancellables = Set<AnyCancellable>()
    private var useCases: ApplicationSettingsUseCases?
    private let currentScreen = "home_screen"

    override func setUpWithError() throws {
        try super.setUpWithError()

        memoryDatabase = PocketGoodsDatabaseBuilder()
            .eraseDatabaseOnSchemaChange(true)
            .inMemory(true)
            .migrationVersion("v1")
            .build()

        let repository = ApplicationSettingsRepositoryImpl(
            database: memoryDatabase
        )

        useCases = ApplicationSettingsUseCases(
            getApplicationSettings: GetApplicationSettingsUseCase(
                repository: repository
            ),
            saveApplicationSettings: SaveApplicationSettingsUseCase(
                repository: repository
            )
        )
    }

    func test_getApplicationSettings_should_stream_app_settings() async throws {
        guard let useCases,
            let memoryDatabase
        else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description: "Should stream application settings"
        )

        try MockData.seedApplicationSettings(
            memoryDatabase: memoryDatabase,
            latestRoute: currentScreen,
            isDarkMode: false
        )

        try useCases
            .getApplicationSettings()
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    XCTFail("Expecting no errors but got \(error)")
                }
            } receiveValue: { [weak self] appSettings in
                guard let self else { return }
                if let appSettings {
                    XCTAssertFalse(appSettings.isDarkMode)
                    XCTAssertEqual(appSettings.latestRoute, currentScreen)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
    }

    func test_saveApplicationSettings_should_save_app_settings() async throws {
        guard let useCases
        else {
            XCTFail("Missing dependencies")
            return
        }

        let expectation = XCTestExpectation(
            description: "Should save application settings"
        )

        var observedAppSettingsValues: [AppSettings?] = []
        let latestRoute = "product_detail_screen"
        let isDarkMode = true

        try useCases
            .getApplicationSettings()
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    XCTFail("Expecting no errors but got \(error)")
                }
            } receiveValue: { appSettings in
                observedAppSettingsValues.append(appSettings)
                if appSettings?.isDarkMode == isDarkMode {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        try useCases.saveApplicationSettings(
            settings: AppSettings(
                isDarkMode: isDarkMode,
                latestRoute: latestRoute
            )
        )

        #if swift(>=5.8)
            await fulfillment(of: [expectation])
        #else
            wait(for: [expectation])
        #endif
        
        XCTAssertTrue(
            observedAppSettingsValues.contains { $0?.isDarkMode == isDarkMode }
        )
        
        XCTAssertTrue(
            observedAppSettingsValues.contains { $0?.latestRoute == latestRoute }
        )
    }
}
