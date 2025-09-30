//
//  Image.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

public struct Image: Sendable, Codable, Equatable {
    public let uuid: String
    public let filename: String
    public let preview: String
    public let original: String

    public init(
        uuid: String,
        filename: String,
        preview: String,
        original: String
    ) {
        self.uuid = uuid
        self.filename = filename
        self.preview = preview
        self.original = original
    }
}
