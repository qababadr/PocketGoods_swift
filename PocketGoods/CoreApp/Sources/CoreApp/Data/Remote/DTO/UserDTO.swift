//
//  UserDTO.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-27.
//

public struct UserDTO: Sendable, Codable {
    public let id: Int64
    public let name: String
    public let email: String
    public let emailVerifiedAt: String?
    public let wishlist: [WishlistItemDTO]

    public init(
        id: Int64,
        name: String,
        email: String,
        emailVerifiedAt: String?,
        wishlist: [WishlistItemDTO]
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.emailVerifiedAt = emailVerifiedAt
        self.wishlist = wishlist
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, email, wishlist
        case emailVerifiedAt = "email_verified_at"
    }
    
    public static func empty() -> UserDTO {
        return .init(
            id: 0,
            name: "",
            email: "",
            emailVerifiedAt: nil,
            wishlist: []
        )
    }
}
