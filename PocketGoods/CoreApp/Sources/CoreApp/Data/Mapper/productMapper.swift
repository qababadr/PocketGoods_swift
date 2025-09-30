//
//  productMapper.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

extension ProductWithImages {
    public func toProduct() -> Product {
        return Product(
            id: product.id,
            title: product.title,
            category: product.category,
            price: product.price,
            quantity: product.quantity,
            description: product.description,
            media: images.map({ $0.toImage() })
        )
    }
}

extension Product {
    public func toProductEntity() -> ProductEntity {
        return ProductEntity(
            id: id,
            title: title,
            category: category,
            price: price,
            quantity: quantity,
            description: description
        )
    }
}

extension ProductDTO {
    public func toProductEntity() -> ProductEntity {
        return ProductEntity(
            id: id,
            title: title,
            category: category,
            price: price,
            quantity: quantity,
            description: description
        )
    }
}

extension ProductPreviewDTO {
    public func toProductPreview() -> ProductPreview {
        return ProductPreview(
            id: id,
            title: title,
            category: category,
            price: price,
            thumbnail: thumbnail
        )
    }
}

extension ProductDTO {
    public func toProduct() -> Product {
        return Product(
            id: id,
            title: title,
            category: category,
            price: price,
            quantity: quantity,
            description: description,
            media: media.map { $0.toImage() }
        )
    }
}
