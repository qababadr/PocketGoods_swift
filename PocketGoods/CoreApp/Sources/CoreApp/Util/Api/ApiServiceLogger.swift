//
//  ApiServiceLogger.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

import Foundation

class ApiServiceLogger {

    static func log(
        request: URLRequest,
        response: URLResponse?,
        responseData: Data?,
        error: Error? = nil
    ) {
        print("\n - - - - - - - - - - API LOG - - - - - - - - - - \n")

        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }

        //MARK: Request section
        print("REQUEST:")

        if let url = request.url {
            print("URL: \(url.absoluteString)")
        }

        if let method = request.httpMethod {
            print("HTTP Method: \(method)")
        }

        if let headers = request.allHTTPHeaderFields {
            print("Headers:")
            headers.forEach { print("\($0): \($1)") }
        }

        if let body = request.httpBody,
            let bodyString = String(data: body, encoding: .utf8)
        {
            print("Body:\n\(bodyString)")
        }

        //MARK: Response section
        print("\nRESPONSE:")
        if let response = response {
            print("URL: \(response.url?.absoluteString ?? "Unknown")")
            print("MIME Type: \(response.mimeType ?? "Unknown")")

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")

                print("Response Headers:")
                for (key, value) in httpResponse.allHeaderFields {
                    print("\(key): \(value)")
                }
            } else {
                print("Non-HTTP Response")
            }
        } else {
            print("Response: None")
        }

        if let data = responseData {
            if let json = try? JSONSerialization.jsonObject(
                with: data,
                options: []
            ) {
                print("Response Body (JSON):\n\(json)")
            } else if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body (String):\n\(responseString)")
            } else {
                print("Response Body: Unable to decode data")
            }
        } else {
            print("Response Body: None")
        }

        if let error {
            print("\nError: \(error.localizedDescription)")
        }
    }
}
