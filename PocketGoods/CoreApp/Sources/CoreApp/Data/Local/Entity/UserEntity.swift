//
//  UserEntity.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation
import GRDB

public struct UserEntity:
    Sendable,
    Identifiable,
    Codable,
    FetchableRecord,
    PersistableRecord
{
    public var id: Int64
    public var name: String
    public var email: String
    public var emailVerifiedAt: Date?
    public static let wishlist = hasMany(
        WishlistItemEntity.self,
        key: "wishlist",
        using: ForeignKey(["user_id"], to: ["id"])
    )
    public var wishlist: QueryInterfaceRequest<WishlistItemEntity> {
        request(for: UserEntity.wishlist)
    }

    public init(
        id: Int64,
        name: String,
        email: String,
        emailVerifiedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.emailVerifiedAt = emailVerifiedAt
    }

    public static var databaseTableName: String { Constant.USERS_TABLE }

    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let email = Column(CodingKeys.email)
        static let emailVerifiedAt = Column(CodingKeys.emailVerifiedAt)
    }

    mutating public func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
    }
}
