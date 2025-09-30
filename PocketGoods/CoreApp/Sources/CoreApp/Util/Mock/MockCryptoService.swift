//
//  MockCryptoService.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

public class MockCryptoService: CryptoService {
    
    public private(set) var isSaved: Bool = false
    private var storedToken: String?
    
    public init() {}
    
    
    public func saveTokenToKeychain(token: String) {
        isSaved = true
        storedToken = token
    }
    
    public func loadTokenFromKeychain() -> String? {
        return storedToken
    }
}
