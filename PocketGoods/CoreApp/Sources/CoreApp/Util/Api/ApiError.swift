//
//  ApiError.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation

public enum ApiError: Error, Equatable {

    public static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.noDataError, .noDataError):
            return true
        case (.missingDependencies, .missingDependencies):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.encodingFailed, .encodingFailed):
            return true

        case (.requestFailed(let lhsError), .requestFailed(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        case (.decodingFailed(let lhsError), .decodingFailed(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
            
        case (.backendError(let lhsError), .backendError(let rhsError)):
            return lhsError.errorMessage == rhsError.errorMessage
       
        default:
            return false

        }
    }

    case requestFailed(Error)
    case decodingFailed(Error)
    case backendError(BackendError)
    case invalidURL
    case invalidResponse
    case noDataError
    case encodingFailed
    case missingDependencies
}
