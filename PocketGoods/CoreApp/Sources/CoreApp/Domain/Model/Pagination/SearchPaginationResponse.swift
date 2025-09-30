//
//  SearchPaginationResponse.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//


public struct SearchPaginationResponse<T: Codable> {
    public let data: [T]
    public let lastPage: Int
    
    public init(data: [T], lastPage: Int) {
        self.data = data
        self.lastPage = lastPage
    }
}
