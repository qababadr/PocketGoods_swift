//
//  SearchPaginationResponseDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct SearchPaginationResponseDTO<T: Codable>: Codable {
    public let data: [T]
    public let lastPage: Int
    
    public init(data: [T], lastPage: Int) {
        self.data = data
        self.lastPage = lastPage
    }
    
    private enum CodingKeys: String, CodingKey {
        case data
        case lastPage = "last_page"
    }
}
