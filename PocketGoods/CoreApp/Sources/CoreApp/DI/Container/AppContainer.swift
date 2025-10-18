//
//  AppContainer.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

import Swinject

@MainActor
public final class AppContainer {

    public static let shared: AppContainer = AppContainer()

    private let container: Container = Container()

    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        container.resolve(serviceType)
    }

    public func register<Service>(
        scope: ObjectScope = .container,
        _ serviceType: Service.Type,
        factory: @escaping (Resolver) -> Service
    ) {
        container
            .register(serviceType) { resolver in factory(resolver) }
            .inObjectScope(scope)
    }

    private init() {}
}
