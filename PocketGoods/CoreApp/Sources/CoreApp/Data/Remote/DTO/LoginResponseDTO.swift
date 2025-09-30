//
//  LoginResponseDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct LoginResponseDTO: Sendable, Codable {
    public let user: UserDTO
    public let token: String

    public init(user: UserDTO, token: String) {
        self.user = user
        self.token = token
    }

    private enum CodingKeys: String, CodingKey {
        case user
        case token
    }
}
