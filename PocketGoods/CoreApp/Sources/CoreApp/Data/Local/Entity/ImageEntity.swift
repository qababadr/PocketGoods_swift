//
//  ImageEntity.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

import GRDB

public struct ImageEntity:
    Sendable,
    Codable,
    EncodableRecord,
    FetchableRecord,
    TableRecord,
    MutablePersistableRecord,
    Equatable
{

    public var uuid: String
    public var modelId: Int64
    public var filename: String
    public var preview: String
    public var original: String

    public init(
        uuid: String,
        modelId: Int64,
        filename: String,
        preview: String,
        original: String
    ) {
        self.uuid = uuid
        self.filename = filename
        self.preview = preview
        self.original = original
        self.modelId = modelId
    }

    public enum Columns {
        static let uuid = Column(CodingKeys.uuid)
        static let filename = Column(CodingKeys.filename)
        static let preview = Column(CodingKeys.preview)
        static let original = Column(CodingKeys.original)
    }
    
    public static var databaseTableName: String { Constant.IMAGES_TABLE }
    
    enum CodingKeys: String, CodingKey {
        case uuid, filename, preview, original
        case modelId = "model_id"
    }
}
