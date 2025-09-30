//
//  PaginationResponse.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

public struct PaginationResponse<T: Codable> {
    public let data: [T]
    public let firstLink: String
    public let lastLink: String
    public let currentPage: Int
    public let from: Int
    public let lastPage: Int
    public let path: String
    public let perPage: Int
    public let to: Int
    public let total: Int
    public let nextLink: String?
    public let prevLink: String?

    public init(
        data: [T],
        firstLink: String,
        lastLink: String,
        currentPage: Int,
        from: Int,
        lastPage: Int,
        path: String,
        perPage: Int,
        to: Int,
        total: Int,
        nextLink: String? = nil,
        prevLink: String? = nil
    ) {
        self.data = data
        self.firstLink = firstLink
        self.lastLink = lastLink
        self.currentPage = currentPage
        self.from = from
        self.lastPage = lastPage
        self.path = path
        self.perPage = perPage
        self.to = to
        self.total = total
        self.nextLink = nextLink
        self.prevLink = prevLink
    }

    public static func empty() -> PaginationResponse<T> {
        PaginationResponse(
            data: [],
            firstLink: "",
            lastLink: "",
            currentPage: 1,
            from: 1,
            lastPage: 1,
            path: "",
            perPage: 1,
            to: 1,
            total: 1,
            nextLink: nil,
            prevLink: nil
        )
    }
}
