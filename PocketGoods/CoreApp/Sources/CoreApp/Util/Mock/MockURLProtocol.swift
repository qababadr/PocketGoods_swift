//
//  MockURLProtocol.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//
import Foundation

public enum WishlistMockState {
    nonisolated(unsafe) public static var currentWishlist: [WishlistItemDTO] =
        MockData.userDTO
        .wishlist
}

extension String {
    func matchesRoute(pattern: String) -> Bool {
        let regexPattern = pattern.replacingOccurrences(
            of: "{id}",
            with: "\\d+"
        )

        guard
            let regex = try? NSRegularExpression(
                pattern: "^" + regexPattern + "$"
            )
        else {
            return false
        }

        let range = NSRange(self.startIndex..<self.endIndex, in: self)

        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}

extension Data {
    init(reading input: InputStream) {
        self.init()

        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)

        defer { buffer.deallocate() }

        while input.hasBytesAvailable {
            let reader = input.read(buffer, maxLength: bufferSize)

            if reader > 0 {
                self.append(buffer, count: reader)
            } else {
                break
            }
        }
    }
}

public class MockURLProtocol: URLProtocol {

    public override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    public override class func canonicalRequest(for request: URLRequest)
        -> URLRequest
    {
        request
    }

    public static func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    public override func startLoading() {
        do {
            let (response, data) = try handler(request)

            client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )

            client?.urlProtocol(self, didLoad: data)

            client?.urlProtocolDidFinishLoading(self)

        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    public override func stopLoading() {}

    public static func getFormData(from request: URLRequest) -> [String: Any]? {
        guard let stream = request.httpBodyStream else { return nil }

        stream.open()

        defer { stream.close() }

        let data = Data(reading: stream)

        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    private func handler(_ request: URLRequest) throws -> (URLResponse, Data) {
        guard let url = request.url else { throw URLError(.badURL) }

        let encoder = JSONEncoder()

        let headers = ["Content-Type": "application/json"]

        switch true {
        case url.path.contains("/products") && request.httpMethod == "GET":
            return try getProducts(
                url: url,
                headers: headers,
                encoder: encoder
            )

        case url.path.contains("/product/details/1")
            && request.httpMethod == "GET":
            return try getProductDetails(
                url: url,
                headers: headers,
                encoder: encoder
            )

        case url.path.contains("/product/search-suggestions")
            && request.httpMethod == "POST":
            return try getSearchSuggestions(
                url: url,
                headers: headers,
                encoder: encoder
            )

        case url.path.contains("/product/search")
            && request.httpMethod == "POST":
            return try searchProducts(
                url: url,
                headers: headers,
                encoder: encoder
            )

        case url.path.contains("/login") && request.httpMethod == "POST":
            return try login(url: url, headers: headers, encoder: encoder)

        case url.path.contains("/register") && request.httpMethod == "PUT":
            return try register(url: url, headers: headers, encoder: encoder)

        case url.path.contains("/logout") && request.httpMethod == "GET":
            return try logout(url: url, headers: headers, encoder: encoder)

        case url.path.contains("/user/is-authenticated")
            && request.httpMethod == "GET":
            return try isAuthenticated(
                url: url,
                headers: headers,
                encoder: encoder
            )

        case url.path.matchesRoute(pattern: "/api/wishlist/toggle/{id}")
            && request.httpMethod == "GET":
            return try toggleWishlist(
                url: url,
                headers: headers,
                encoder: encoder
            )

        case url.path.contains("/wishlist/list") && request.httpMethod == "GET":
            return try getEntireWishlist(
                url: url,
                headers: headers,
                encoder: encoder
            )

        default:
            throw NSError(domain: "\(url.path) is not supported", code: 400)
        }

    }
}
