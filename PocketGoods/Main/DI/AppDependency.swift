//
//  AppDependency.swift
//  PocketGoods
//
//  Created by BADR  QABA on 2025-10-13.
//

import AuthenticationFeature
import CoreApp
import ProductFeature
import SettingsFeature
import WishlistFeature

public final class AppDependency {
    public static let shared = AppDependency()

    @IsInTestEnvironment
    private var isInTestEnvironment: Bool

    private init() {}

    @MainActor
    public func installDependencies() {
        if isInTestEnvironment {
            AppTestModule.install()
        } else {
            CoreAppDataModule.install()
            AuthenticationFeatureDomainModule.install()
            WishlistFeatureDomainModule.install()
            ProductFeatureDomainModule.install()
            ApplicationSettingsFeatureDomainModule.install()
        }
    }
}
