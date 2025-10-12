//
//  GetApplicationSettingsUseCase.swift
//  SettingsFeature
//
//  Created by BADR  QABA on 2025-10-12.
//

import Combine
import CoreApp
import Foundation

public final class GetApplicationSettingsUseCase {

    private let repository: ApplicationSettingsRepository?

    public init(repository: ApplicationSettingsRepository?) {
        self.repository = repository
    }

    public func callAsFunction() throws -> AnyPublisher<
        AppSettings?, ApiError
    > {
        guard let repository else {
            return Fail(error: ApiError.missingDependencies)
                .eraseToAnyPublisher()
        }
        return try repository.getApplicationSettings()
    }
}
