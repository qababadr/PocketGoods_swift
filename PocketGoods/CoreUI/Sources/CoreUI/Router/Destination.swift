//
//  Destination.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

public enum Destination: Codable, Hashable {
    case HomeScreen
    case ProductDetailScreen(productId: Int64)
    case WishlistManagerScreen
    case ProductSearchResultScreen
    case UnAuthorizedScreen

    public var rawValue: String {
        switch self {
        case .HomeScreen:
            return "home_screen"
        case .ProductDetailScreen(let productId):
            return "product_detail_screen/\(productId)"
        case .WishlistManagerScreen:
            return "wishlist_manager_screen"
        case .ProductSearchResultScreen:
            return "product_search_result_screen"
        case .UnAuthorizedScreen:
            return "unauthorized_screen"
        }
    }

    public init?(rawValue: String) {
        let parts = rawValue.split(
            separator: "/",
            omittingEmptySubsequences: false
        )

        switch parts.first {
        case "home_screen":
            self = .HomeScreen

        case "wishlist_manager_screen":
            self = .WishlistManagerScreen

        case "product_search_result_screen":
            self = .ProductSearchResultScreen

        case "unauthorized_screen":
            self = .UnAuthorizedScreen
            
        case "product_detail_screen":
            if parts.count == 2,
               let productId = Int64(parts[1]) {
                self = .ProductDetailScreen(productId: productId)
            } else {
                return nil
            }

        default:
            return nil
        }
    }
    
    public var isPrivateDestination: Bool {
        switch self {
        case .WishlistManagerScreen:
            return true
            
        case .HomeScreen,
                .ProductDetailScreen,
                .ProductSearchResultScreen,
                .UnAuthorizedScreen:
            return false
        }
    }
}
