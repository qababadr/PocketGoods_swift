//
//  ApiService.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation

internal enum HTTPRequestMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

public final class ApiService: Sendable {

    private let baseUrl: String?
    private let timeoutInterval: Double
    private let session: URLSession
    private let withBackground: Bool
    private let withLogger: Bool

    init(
        session: URLSession,
        withBackground: Bool,
        timeout: Double = 60,
        baseUrl: String? = nil,
        withLogger: Bool = false
    ) {
        self.baseUrl = baseUrl
        timeoutInterval = timeout
        self.session = session
        self.withBackground = withBackground
        self.withLogger = withLogger
    }

    public func get<T: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        baseUrl: String? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        do {
            let data = try await makeRequest(
                endPoint: endPoint,
                method: .GET,
                baseUrl: self.baseUrl ?? baseUrl,
                headers: headers
            )

            let decodedResponse = try JSONDecoder()
                .decode(ApiResponse<T>.self, from: data)

            return decodedResponse.data

        } catch {
            throw ApiError.decodingFailed(error)
        }
    }

    public func rawGet<T: Codable>(
        endPoint: String,
        of: T.Type,
        baseUrl: String? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        do {
            let data = try await makeRequest(
                endPoint: endPoint,
                method: .GET,
                baseUrl: self.baseUrl ?? baseUrl,
                headers: headers
            )

            return try JSONDecoder()
                .decode(of, from: data)

        } catch {
            throw ApiError.decodingFailed(error)
        }
    }
    
    public func rawPost<T: Decodable>(
        endPoint: String,
        of: T.Type,
        data: Data?,
        baseUrl: String? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        do {
            let response = try await makeRequest(
                endPoint: endPoint,
                method: .POST,
                baseUrl: self.baseUrl ?? baseUrl,
                data: data,
                headers: headers
            )
            return try JSONDecoder().decode(T.self, from: response)
        } catch {
            throw ApiError.decodingFailed(error)
        }
    }
    
    
    public func post<T: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        data: Data?,
        baseUrl: String? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        do {
            let response = try await makeRequest(
                endPoint: endPoint,
                method: .POST,
                baseUrl: self.baseUrl ?? baseUrl,
                data: data,
                headers: headers
            )
            let decodedResponse = try JSONDecoder().decode(
                ApiResponse<T>.self,
                from: response
            )
            return decodedResponse.data
        } catch {
            throw ApiError.decodingFailed(error)
        }
    }
    
    public func put<T: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        data: Data? = nil,
        baseUrl: String? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        do {
            let response = try await makeRequest(
                endPoint: endPoint,
                method: .PUT,
                baseUrl: self.baseUrl ?? baseUrl,
                data: data,
                headers: headers
            )
            let decodedResponse = try JSONDecoder().decode(
                ApiResponse<T>.self,
                from: response
            )
            return decodedResponse.data
        } catch {
            throw ApiError.decodingFailed(error)
        }
    }

    private func makeRequest(
        endPoint: String,
        method: HTTPRequestMethod,
        baseUrl: String? = nil,
        data: Data? = nil,
        headers: [String: String] = [:]
    ) async throws -> Data {
        let stringUrl = (baseUrl ?? self.baseUrl ?? "") + endPoint

        guard let url = URL(string: stringUrl) else {
            throw ApiError.invalidURL
        }

        let request: URLRequest = {
            var req = URLRequest(url: url)
            req.httpMethod = method.rawValue
            req.timeoutInterval = self.timeoutInterval
            req.setValue("application/json", forHTTPHeaderField: "Accept")

            if method == .PUT || method == .POST {
                if let bodyData = data {
                    req.httpBody = bodyData
                }
                req.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
            }

            headers.forEach { key, value in
                req.addValue(value, forHTTPHeaderField: key)
            }

            return req
        }()

        do {
            let (data, response): (Data, URLResponse)

            if withBackground {
                (data, response) = try await session.data(for: request)
            } else {
                (data, response) = try await withTaskCancellationHandler {
                    try await session.data(for: request)
                } onCancel: {
                    let task = session.downloadTask(with: request)
                    task.resume()
                }
            }

            if withLogger {
                ApiServiceLogger.log(
                    request: request,
                    response: response,
                    responseData: data
                )
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw ApiError.invalidResponse
            }

            return data

        } catch {
            throw ApiError.requestFailed(error)
        }
    }
}
