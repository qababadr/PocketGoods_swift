//
//  AuthenticationMockRequest.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

import Foundation

extension MockURLProtocol {

    func login(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {
        if let json = MockURLProtocol.getFormData(from: request),
            let email = json["email"] as? String,
            let password = json["password"] as? String
        {
            let response: HTTPURLResponse
            let responseData: Data

            if email == MockData.correctEmail
                && password == MockData.correctPassword
            {
                let loginResponse = LoginResponseDTO(
                    user: MockData.userDTO,
                    token: MockData.token
                )

                let apiResponse = ApiResponse(data: loginResponse)

                response = HTTPURLResponse(
                    url: url,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: headers
                )!

                responseData = try encoder.encode(apiResponse)
            } else {
                let unauthorizedResponse = ApiResponse<LoginResponseDTO>(
                    data: LoginResponseDTO(user: UserDTO.empty(), token: "")
                )

                response = HTTPURLResponse(
                    url: url,
                    statusCode: 401,
                    httpVersion: nil,
                    headerFields: headers
                )!

                responseData = try encoder.encode(unauthorizedResponse)
            }

            return (response, responseData)

        } else {
            throw NSError(domain: "Unsupported payload", code: 400)
        }
    }

    func register(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {
        if let json = MockURLProtocol.getFormData(from: request),
            let name = json["name"] as? String,
            let email = json["email"] as? String,
            let password = json["password"] as? String,
            let passwordConfirmation = json["password_confirmation"]
                as? String
        {
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: headers
            )!

            let responseData: Data = try encoder.encode(
                MockData.registerResponse(
                    fullName: name,
                    email: email,
                    password: password,
                    passwordConfirmation: passwordConfirmation
                )
            )

            return (response, responseData)

        } else {
            throw NSError(domain: "Unsupported payload", code: 400)
        }
    }

    func isAuthenticated(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {
        let tokenFromHeader = request.value(forHTTPHeaderField: "Authorization")
        let hasCorrectToken = tokenFromHeader == "Bearer \(MockData.token)"

        let response = HTTPURLResponse(
            url: url,
            statusCode: hasCorrectToken ? 200 : 401,
            httpVersion: nil,
            headerFields: headers
        )!

        let responseData = try encoder.encode(
            MockData.authenticatedUserResponse(hasCorrectToken: hasCorrectToken)
        )

        return (response, responseData)
    }

    func logout(
        url: URL,
        headers: [String: String],
        encoder: JSONEncoder
    ) throws -> (URLResponse, Data) {
        let tokenFromHeader = request.value(forHTTPHeaderField: "Authorization")
        let hasCorrectToken = tokenFromHeader == "Bearer \(MockData.token)"

        let response = HTTPURLResponse(
            url: url,
            statusCode: hasCorrectToken ? 200 : 401,
            httpVersion: nil,
            headerFields: headers
        )!

        let responseData = try encoder.encode(
            MockData.logoutResponse(hasCorrectToken: hasCorrectToken)
        )

        return (response, responseData)
    }
}
