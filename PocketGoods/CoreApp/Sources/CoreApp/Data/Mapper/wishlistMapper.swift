//
//  wishlistMapper.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

extension WishlistItemEntity {
    public func toWishlistItem() -> WishlistItem {
        return WishlistItem(
            id: id,
            productId: productId,
            productDetail: nil
        )
    }
}

extension WishlistItem {
    public func toWishlistItemEntity(userId: Int64) -> WishlistItemEntity {
        return WishlistItemEntity(
            id: id,
            productId: productId,
            userId: userId
        )
    }

    public func toWishlistDTO() -> WishlistItemDTO {
        let empty = ProductDTO.empty()
        return WishlistItemDTO(
            id: id,
            productId: productId,
            productDetail: ProductDTO(
                id: productDetail?.id ?? empty.id,
                title: productDetail?.title ?? empty.title,
                category: productDetail?.category ?? empty.category,
                price: productDetail?.price ?? empty.price,
                quantity: productDetail?.quantity ?? empty.quantity,
                description: productDetail?.description ?? empty.description,
                media: productDetail?.media.map({
                    ImageDTO(
                        uuid: $0.uuid,
                        filename: $0.filename,
                        preview: $0.preview,
                        original: $0.original
                    )
                }) ?? empty.media
            )
        )
    }
}

extension WishlistItemDTO {
    public func toWishlistItem() -> WishlistItem {
        return WishlistItem(
            id: id,
            productId: productId,
            productDetail: productDetail?.toProduct()
        )
    }

    public func toWishlistItemEntity(userId: Int64) -> WishlistItemEntity {
        return WishlistItemEntity(
            id: id,
            productId: productId,
            userId: userId
        )
    }
}
