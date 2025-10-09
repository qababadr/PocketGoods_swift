//
//  AuthenticationRepository.swift
//  AuthenticationFeature
//
//  Created by BADR  QABA on 2025-10-08.
//
import Combine
import CoreApp

public protocol AuthenticationRepository {
    
    func login(
        email: String,
        password: String
    ) async throws -> AnyPublisher<User?, ApiError>
    
    func register(
        fullName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) async throws -> String
    
    func getAuthenticatedUser() async -> AnyPublisher<Resource<User?>, ApiError>
    
    func getCachedAuthenticatedUser(
        userId: Int64
    ) throws -> AnyPublisher<User?, ApiError>
    
    func logout(userId: Int64) async throws -> Bool
    
    func clearCachedUser() async
}
