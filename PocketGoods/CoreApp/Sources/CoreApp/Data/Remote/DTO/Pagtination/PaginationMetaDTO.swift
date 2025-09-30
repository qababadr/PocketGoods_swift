//
//  PaginationMetaDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct PaginationMetaDTO: Sendable, Codable {
    public let currentPage: Int
    public let from: Int
    public let lastPage: Int
    public let path: String
    public let perPage: Int
    public let to: Int
    public let total: Int

    public init(
        currentPage: Int,
        from: Int,
        lastPage: Int,
        path: String,
        perPage: Int,
        to: Int,
        total: Int
    ) {
        self.currentPage = currentPage
        self.from = from
        self.lastPage = lastPage
        self.path = path
        self.perPage = perPage
        self.to = to
        self.total = total
    }

    private enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case path
        case perPage = "per_page"
        case to
        case total
    }
}
