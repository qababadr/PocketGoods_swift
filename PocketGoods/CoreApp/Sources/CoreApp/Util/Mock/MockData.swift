//
//  MockData.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

import Foundation

public struct MockData {
    public static let token =
        "28|zzpMGvjoMKDlu3PfJX7rLydMLNMtODuy3dOqjoqRea0ca3fe"
    
    public static let correctEmail = "email@email.email"
    public static let correctPassword = "Password@1"
    
    public static func seedDatabase(memoryDatabase: PocketGoodsDatabaseManager) throws {

        try memoryDatabase.insert(MockData.userDTO.toUserEntity())
        try MockData
            .userDTO
            .wishlist
            .forEach { wishlistItemDTO in
                if let productDetail = wishlistItemDTO.productDetail {
                    try memoryDatabase.insert(productDetail.toProductEntity())

                    try productDetail
                        .media
                        .forEach { imageDTO in
                            try memoryDatabase.insert(
                                imageDTO.toImageEntity(
                                    productId: productDetail.id
                                )
                            )
                        }
                }

                try memoryDatabase.insert(
                    wishlistItemDTO.toWishlistItemEntity(
                        userId: MockData.userDTO.id
                    )
                )
            }
    }

    public static let userDTO = UserDTO(
        id: 6,
        name: "badr qaba",
        email: "email@email.email",
        emailVerifiedAt: nil,
        wishlist: [
            WishlistItemDTO(
                id: 7,
                productId: 3,
                productDetail: ProductDTO(
                    id: 3,
                    title: "Headphones",
                    category: "Electronics",
                    price: 129.99,
                    quantity: 150,
                    description: "Noise-cancelling over-ear headphones.",
                    media: [
                        ImageDTO(
                            uuid: "eebfe1cc-2891-4bec-91ce-74def6c7a98d",
                            filename:
                                "headphones-814055_1280image-by-stephanie-robertson-from-pixabay.jpg",
                            preview:
                                "\(Constant.HOST)/media/5/conversions/headphones-814055_1280image-by-stephanie-robertson-from-pixabay-thumbnail.jpg",
                            original:
                                "\(Constant.HOST)/media/5/headphones-814055_1280image-by-stephanie-robertson-from-pixabay.jpg"
                        ),
                        ImageDTO(
                            uuid: "d6c9ca2a-e300-4231-9278-70693694fce4",
                            filename:
                                "image-by-dmitrijs-bojarovs-from-pixabay.jpg",
                            preview:
                                "\(Constant.HOST)/media/6/conversions/image-by-dmitrijs-bojarovs-from-pixabay-thumbnail.jpg",
                            original:
                                "\(Constant.HOST)/media/6/image-by-dmitrijs-bojarovs-from-pixabay.jpg"
                        ),
                    ]
                )
            ),
            WishlistItemDTO(
                id: 12,
                productId: 1,
                productDetail: ProductDTO(
                    id: 1,
                    title: "Sunglasses",
                    category: "Accessories",
                    price: 20.99,
                    quantity: 100,
                    description: "Stylish sunglasses for a sunny day.",
                    media: [
                        ImageDTO(
                            uuid: "9837ee14-758a-4052-97cd-83c9ee4c2fdc",
                            filename:
                                "aviator-sunglasses-2592111_1280_image-by-sandeep-handa-from-pixabay.jpg",
                            preview:
                                "\(Constant.HOST)/media/1/conversions/aviator-sunglasses-2592111_1280_image-by-sandeep-handa-from-pixabay-thumbnail.jpg",
                            original:
                                "\(Constant.HOST)/media/1/aviator-sunglasses-2592111_1280_image-by-sandeep-handa-from-pixabay.jpg"
                        ),
                        ImageDTO(
                            uuid: "48423fd0-5b18-4604-846f-3c9e72d19056",
                            filename:
                                "sunglasses-178151_1280image-by-pawet-ludzinski-from-pixabay.jpg",
                            preview:
                                "\(Constant.HOST)/media/2/conversions/sunglasses-178151_1280image-by-pawet-ludzinski-from-pixabay-thumbnail.jpg",
                            original:
                                "\(Constant.HOST)/media/2/sunglasses-178151_1280image-by-pawet-ludzinski-from-pixabay.jpg"
                        ),
                    ]
                )
            ),
        ]
    )

    public static let productsPaginationResponse = PaginationResponseDTO(
        data: [
            ProductPreviewDTO(
                id: 1,
                title: "Sunglasses",
                category: "Accessories",
                price: 20.99,
                thumbnail:
                    "\(Constant.HOST)/media/1/conversions/aviator-sunglasses-2592111_1280_image-by-sandeep-handa-from-pixabay-thumbnail.jpg"
            ),
            ProductPreviewDTO(
                id: 2,
                title: "Parfum",
                category: "Beauty",
                price: 49.99,
                thumbnail:
                    "\(Constant.HOST)/media/3/conversions/fragonard-1007437_1280image-by-nathaly-durepaire-from-pixabay-thumbnail.jpg"
            ),
            ProductPreviewDTO(
                id: 3,
                title: "Headphones",
                category: "Electronics",
                price: 129.99,
                thumbnail:
                    "\(Constant.HOST)/media/5/conversions/headphones-814055_1280image-by-stephanie-robertson-from-pixabay-thumbnail.jpg"
            ),
            ProductPreviewDTO(
                id: 4,
                title: "Makeup",
                category: "Beauty",
                price: 19.99,
                thumbnail:
                    "\(Constant.HOST)/media/7/conversions/image-by-aerngaoey-from-pixabay-thumbnail.jpg"
            ),
            ProductPreviewDTO(
                id: 5,
                title: "Wrist Watch",
                category: "Accessories",
                price: 149.99,
                thumbnail:
                    "\(Constant.HOST)/media/9/conversions/image-by-emamul-andalib-from-pixabay-thumbnail.jpg"
            ),
            ProductPreviewDTO(
                id: 6,
                title: "Coffee",
                category: "Grocery",
                price: 9.99,
                thumbnail:
                    "\(Constant.HOST)/media/11/conversions/coffee-5568374-1280-thumbnail.jpg"
            ),
            ProductPreviewDTO(
                id: 7,
                title: "Lipstick",
                category: "Beauty",
                price: 24.99,
                thumbnail:
                    "\(Constant.HOST)/media/13/conversions/image-by-steve-jang-from-pixabay-thumbnail.jpg"
            ),
            ProductPreviewDTO(
                id: 8,
                title: "Microphone",
                category: "Electronics",
                price: 79.99,
                thumbnail:
                    "\(Constant.HOST)/media/15/conversions/image-by-la88au88ra-from-pixabay-thumbnail.jpg"
            ),
            ProductPreviewDTO(
                id: 9,
                title: "Washing Machine Liquid",
                category: "Home",
                price: 7.99,
                thumbnail:
                    "\(Constant.HOST)/media/17/conversions/image-by-martins2018-from-pixabay-thumbnail.jpg"
            ),
        ],
        links: PaginationLinksDTO(
            first: "\(Constant.HOST)/api/products?page=1",
            last: "\(Constant.HOST)/api/products?page=2",
            next: "\(Constant.HOST)/api/products?page=2",
            prev: nil
        ),
        meta: PaginationMetaDTO(
            currentPage: 1,
            from: 1,
            lastPage: 2,
            path: "\(Constant.HOST)/api/products",
            perPage: 9,
            to: 9,
            total: 12
        )
    )

    public static let sunGlassesProductResponse = ApiResponse(
        data: Product(
            id: 1,
            title: "Sunglasses",
            category: "Accessories",
            price: 20.99,
            quantity: 100,
            description: "Stylish sunglasses for a sunny day.",
            media: [
                Image(
                    uuid: "9837ee14-758a-4052-97cd-83c9ee4c2fdc",
                    filename:
                        "aviator-sunglasses-2592111_1280_image-by-sandeep-handa-from-pixabay.jpg",
                    preview:
                        "\(Constant.HOST)/media/1/conversions/aviator-sunglasses-2592111_1280_image-by-sandeep-handa-from-pixabay-thumbnail.jpg",
                    original:
                        "\(Constant.HOST)/media/1/aviator-sunglasses-2592111_1280_image-by-sandeep-handa-from-pixabay.jpg"
                ),
                Image(
                    uuid: "48423fd0-5b18-4604-846f-3c9e72d19056",
                    filename:
                        "sunglasses-178151_1280image-by-pawet-ludzinski-from-pixabay.jpg",
                    preview:
                        "\(Constant.HOST)/media/2/conversions/sunglasses-178151_1280image-by-pawet-ludzinski-from-pixabay-thumbnail.jpg",
                    original:
                        "\(Constant.HOST)/media/2/sunglasses-178151_1280image-by-pawet-ludzinski-from-pixabay.jpg"
                ),
            ]
        )
    )

    public static func suggestedProducts(query: String) -> ApiResponse<
        [ProductPreviewDTO]
    > {
        ApiResponse(
            data: productsPaginationResponse
                .data
                .filter {
                    $0.title.contains(query)
                }
        )
    }

    public static func searchPaginationResponse(query: String)
        -> PaginationResponseDTO<ProductPreviewDTO>
    {
        let data = productsPaginationResponse.data.filter {
            $0.title.contains(query)
        }
        return PaginationResponseDTO(
            data: data,
            links: productsPaginationResponse.links,
            meta: productsPaginationResponse.meta.copyWith(total: data.count)
        )
    }

    public static let loginResponse = ApiResponse(
        data: LoginResponseDTO(user: userDTO, token: token)
    )

    public static func registerResponse(
        fullName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) -> ApiResponse<String?> {
        let data =
            (!fullName.isEmpty && !email.isEmpty
                && password == passwordConfirmation) ? "Registered" : nil
        return ApiResponse(data: data)
    }

    public static func authenticatedUserResponse(hasCorrectToken: Bool)
        -> ApiResponse<UserDTO?>
    {
        ApiResponse(data: hasCorrectToken ? userDTO : nil)
    }

    public static func logoutResponse(hasCorrectToken: Bool) -> ApiResponse<
        Bool?
    > {
        ApiResponse(data: hasCorrectToken ? true : nil)
    }

    public static let insertedWishlistItemId: Int64 = 13

    public static let savedAppSetting = AppSettings(isDarkMode: true)
}

extension PaginationMetaDTO {
    fileprivate func copyWith(total: Int) -> PaginationMetaDTO {
        .init(
            currentPage: self.currentPage,
            from: self.from,
            lastPage: self.lastPage,
            path: self.path,
            perPage: self.perPage,
            to: self.to,
            total: total
        )
    }
}
