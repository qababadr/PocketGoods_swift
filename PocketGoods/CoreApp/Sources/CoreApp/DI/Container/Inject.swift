//
//  Inject.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

@propertyWrapper
public struct Inject<Service> {

    public let wrappedValue: Service

    public init() {
        guard
            let service = AppContainer
                .shared
                .resolve(Service.self)
        else {
            fatalError("Dependency of type \(Service.self) is not found!")
        }

        wrappedValue = service
    }
}
