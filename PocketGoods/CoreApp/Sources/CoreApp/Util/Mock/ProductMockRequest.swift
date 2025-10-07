//
//  ProductMockRequest.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//
import Foundation

extension MockURLProtocol {

    func getProducts(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: headers
        )!

        let responseData = try encoder.encode(
            MockData.productsPaginationResponse
        )

        return (response, responseData)
    }

    func getProductDetails(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {
        let response: HTTPURLResponse
        let responseData: Data

        let correctResponse = MockData.sunGlassesProductResponse

        if let path = url.path.split(separator: "/").last,
            let productId = Int64(path),
            productId == correctResponse.data.id
        {

            response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: headers
            )!

            responseData = try encoder.encode(correctResponse)

        } else {
            response = HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: headers
            )!

            responseData = try encoder.encode(
                ApiResponse<ProductDTO>(data: ProductDTO.empty())
            )
        }

        return (response, responseData)
    }

    func getSearchSuggestions(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {

        if let json = MockURLProtocol.getFormData(from: request),
            let searchQuery = json["search_query"] as? String
        {

            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: headers
            )!

            let responseData = try encoder.encode(
                MockData.suggestedProducts(query: searchQuery)
            )

            return (response, responseData)

        } else {
            throw NSError(domain: "Unsupported payload", code: 400)
        }
    }

    func searchProducts(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {
        if let json = MockURLProtocol.getFormData(from: request),
            let searchQuery = json["search_query"] as? String
        {
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: headers
            )!

            let responseData = try encoder.encode(
                MockData.searchPaginationResponse(query: searchQuery)
            )
            
            return (response, responseData)
            
        } else {
            throw NSError(domain: "Unsupported payload", code: 400)
        }
    }
}
