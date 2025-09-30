//
//  CryptoServiceImpl.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

import Foundation

public class CryptoServiceImpl: CryptoService {
    
    private let service = "com.badrqaba.pocketgoods"
    private let account = "apiToken"
    
    public func saveTokenToKeychain(token: String) {
        
        guard let tokenData = token.data(using: .utf8) else {
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: tokenData
        ]
        
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
    }

    public func loadTokenFromKeychain() -> String? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }

}
