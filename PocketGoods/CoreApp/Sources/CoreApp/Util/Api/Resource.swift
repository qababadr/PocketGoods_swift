//
//  Resource.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

public enum Resource<T> {
    case empty
    case loading(data: T?)
    case success(data: T)
    case error(data: T?, error: Error?)

    public var data: T? {
        switch self {

        case .empty:
            nil
        case .loading(let data), .error(let data, error: _):
            data
        case .success(let data):
            data
        }
    }

    public var error: Error? {
        switch self {
        case .error(_, let error):
            return error
        default:
            return nil
        }
    }
    
    public var isEmpty: Bool {
        if case .empty = self {
            return true
        }
        return false
    }
    
    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    public var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    public var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
}
