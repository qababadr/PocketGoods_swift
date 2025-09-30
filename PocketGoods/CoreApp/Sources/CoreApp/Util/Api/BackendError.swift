//
//  BackendError.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

public struct BackendError: Sendable, Codable {
    public let errorMessage: String
    public let errors: [String: [String]]?

    public init(errorMessage: String, errors: [String: [String]]? = nil) {
        self.errorMessage = errorMessage
        self.errors = errors
    }

    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
        case errors
    }
}
