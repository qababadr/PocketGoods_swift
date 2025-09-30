//
//  imageMapper.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

extension ImageEntity {
    public func toImage() -> Image {
        return Image(
            uuid: uuid,
            filename: filename,
            preview: preview,
            original: original
        )
    }
}

extension Image {
    public func toImageEntity(productId: Int64) -> ImageEntity {
        return ImageEntity(
            uuid: uuid,
            modelId: productId,
            filename: filename,
            preview: preview,
            original: original
        )
    }
}

extension ImageDTO {
    public func toImageEntity(productId: Int64) -> ImageEntity {
        return ImageEntity(
            uuid: uuid,
            modelId: productId,
            filename: filename,
            preview: preview,
            original: original
        )
    }
    
    public func toImage() -> Image {
        return Image(
            uuid: uuid,
            filename: filename,
            preview: preview,
            original: original
        )
    }
}
