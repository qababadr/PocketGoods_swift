//
//  IsInTestEnvironment.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

import Foundation

@propertyWrapper
public struct IsInTestEnvironment {

    public static let testProcessArgument = "in-test-env"

    public var wrappedValue: Bool

    public init() {
        self.wrappedValue = ProcessInfo.processInfo
            .arguments
            .contains(IsInTestEnvironment.testProcessArgument)
    }
}
