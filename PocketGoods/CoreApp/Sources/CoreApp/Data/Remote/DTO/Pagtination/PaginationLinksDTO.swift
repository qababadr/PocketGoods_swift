//
//  PaginationLinksDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct PaginationLinksDTO: Sendable, Codable {
    public let first: String
    public let last: String
    public let next: String?
    public let prev: String?

    public init(first: String, last: String, next: String?, prev: String?) {
        self.first = first
        self.last = last
        self.next = next
        self.prev = prev
    }

    private enum CodingKeys: String, CodingKey {
        case first, last, next, prev
    }
}
