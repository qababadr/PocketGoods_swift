//
//  PaginationResponseDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct PaginationResponseDTO<T: Sendable & Codable>: Sendable, Codable {
    public let data: [T]
    public let links: PaginationLinksDTO
    public let meta: PaginationMetaDTO
    
    public init(data: [T], links: PaginationLinksDTO, meta: PaginationMetaDTO) {
        self.data = data
        self.links = links
        self.meta = meta
    }
    
    private enum CodingKeys: String, CodingKey {
        case data, links, meta
    }
}
