//
//  WishlistMockRequest.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//
import Foundation

extension MockURLProtocol {
    func toggleWishlist(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {
        if let path = url.path.split(separator: "/").last,
            let productId = Int64(path)
        {
            let tokenFromHeader = request.value(
                forHTTPHeaderField: "Authorization"
            )

            let response: HTTPURLResponse
            let responseData: Data
            let hasCorrectToken = tokenFromHeader == "Bearer \(MockData.token)"

            if hasCorrectToken {
                var wishlist = WishlistMockState.currentWishlist
                let index = wishlist.firstIndex { $0.productId == productId }

                let wishlistItemId: Int64
                let insertedProduct: ProductDTO?

                if let index {
                    wishlist.remove(at: index)
                    wishlistItemId = -1
                    insertedProduct = nil
                } else {
                    let productDTO = MockData
                        .userDTO
                        .wishlist
                        .filter {
                            $0.productId
                                == MockData.sunGlassesProductResponse.data.id
                        }
                        .first?
                        .productDetail

                    let newItem = WishlistItemDTO(
                        id: MockData.insertedWishlistItemId,
                        productId: productId,
                        productDetail: productDTO
                    )

                    wishlist.append(newItem)
                    wishlistItemId = newItem.id
                    insertedProduct = productDTO
                }

                WishlistMockState.currentWishlist = wishlist

                response = HTTPURLResponse(
                    url: url,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: headers
                )!

                responseData = try encoder.encode(
                    ApiResponse(
                        data: WishlistResponseDTO(
                            inWishlist: wishlistItemId != -1,
                            wishlistItemId: wishlistItemId,
                            product: insertedProduct
                        )
                    )
                )

            } else {
                response = HTTPURLResponse(
                    url: url,
                    statusCode: 401,
                    httpVersion: nil,
                    headerFields: headers
                )!
                responseData = try encoder.encode(
                    ApiResponse<[WishlistItemDTO]>(data: [])
                )
            }

            return (response, responseData)
        }

        throw NSError(domain: "Unsupported payload", code: 400)
    }

    func getEntireWishlist(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {
        let tokenFromHeader = request.value(
            forHTTPHeaderField: "Authorization"
        )
        let response: HTTPURLResponse
        let responseData: Data
        let hasCorrectToken = tokenFromHeader == "Bearer \(MockData.token)"

        if hasCorrectToken {
            response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: headers
            )!
            responseData = try encoder.encode(
                ApiResponse<[WishlistItemDTO]>(
                    data: WishlistMockState.currentWishlist
                )
            )
        } else {
            response = HTTPURLResponse(
                url: url,
                statusCode: 401,
                httpVersion: nil,
                headerFields: headers
            )!
            responseData = try encoder.encode(
                ApiResponse<[WishlistItemDTO]>(data: [])
            )
        }

        return (response, responseData)
    }
}
