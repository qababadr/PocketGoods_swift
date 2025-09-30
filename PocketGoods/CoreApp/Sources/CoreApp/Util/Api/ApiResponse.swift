//
//  ApiResponse.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

public struct ApiResponse<T: Sendable & Codable>: Sendable, Codable {
    public let data: T
}
