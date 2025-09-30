//
//  userMapper.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

extension UserWithWishlistAndProductAndImages {
    public func toUser() -> User {
        return User(
            id: user.id,
            name: user.name,
            email: user.email,
            emailVerifiedAt: user.emailVerifiedAt,
            wishlist: wishlist.map({ item in

                var product: Product? = nil

                if let productItem = item.productWithImages?.product {

                    let images = item.productWithImages?.images ?? []

                    product = Product(
                        id: productItem.id,
                        title: productItem.title,
                        category: productItem.category,
                        price: productItem.price,
                        quantity: productItem.quantity,
                        description: productItem.description,
                        media: images.map({ $0.toImage() })
                    )
                }

                return WishlistItem(
                    id: item.wishlist.id,
                    productId: item.wishlist.productId,
                    productDetail: product
                )
            })
        )
    }
}

extension UserDTO {

    public func toUserEntity() -> UserEntity {
        return UserEntity(
            id: id,
            name: name,
            email: email,
            emailVerifiedAt: emailVerifiedAt?.toDate()
        )
    }

    public func toUser() -> User {
        return User(
            id: id,
            name: name,
            email: email,
            emailVerifiedAt: emailVerifiedAt?.toDate(),
            wishlist: wishlist.map { $0.toWishlistItem() }
        )
    }

    public func copy(
        id: Int64? = nil,
        name: String? = nil,
        email: String? = nil,
        emailVerifiedAt: String? = nil,
        wishlist: [WishlistItemDTO]? = nil
    ) -> UserDTO {
        return UserDTO(
            id: id ?? self.id,
            name: name ?? self.name,
            email: email ?? self.email,
            emailVerifiedAt: emailVerifiedAt,
            wishlist: wishlist ?? self.wishlist
        )
    }
}
