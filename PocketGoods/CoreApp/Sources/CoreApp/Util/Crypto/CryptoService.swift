//
//  CryptoService.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-29.
//

public protocol CryptoService {
    
    func saveTokenToKeychain(token: String)
    
    func loadTokenFromKeychain() -> String?
}
