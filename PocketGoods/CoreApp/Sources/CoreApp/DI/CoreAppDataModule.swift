//
//  CoreAppDataModule.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//
import Swinject

public struct CoreAppDataModule {

    private init() {}

    @MainActor
    public static func install() {
        AppContainer
            .shared
            .register(ApiService.self) {
                CoreAppDataModule.provideApiService(resolver: $0)
            }
        
        AppContainer
            .shared
            .register(PocketGoodsDatabaseManager.self) {
                CoreAppDataModule.providePocketGoodsDatabaseManager(resolver: $0)
            }
        
        AppContainer
            .shared
            .register(CryptoService.self) {
                CoreAppDataModule.provideCryptoService(resolver: $0)
            }
    }

    private static func provideApiService(resolver: Resolver) -> ApiService {
        return ApiServiceBuilder()
            .timeout(timeout: Constant.REQUEST_TIMEOUT)
            .session(session: .shared)
            .baseUrl(stringUrl: Constant.API_BASE_URL)
            .withLogger()
            .build()
    }

    private static func providePocketGoodsDatabaseManager(resolver: Resolver)
        -> PocketGoodsDatabaseManager
    {
        return PocketGoodsDatabaseBuilder()
            .databaseName(Constant.DATABASE_NAME)
            .databaseExtension(Constant.DATABASE_FILE_EXTENSION)
            .eraseDatabaseOnSchemaChange(true)
            .inMemory(false)
            .cacheFolderName(Constant.APP_CACHE_DIR)
            .migrationVersion(Constant.DATABASE_VERSION)
            .build()
    }

    private static func provideCryptoService(resolver: Resolver)
        -> CryptoService
    {
        return CryptoServiceImpl()
    }
}
