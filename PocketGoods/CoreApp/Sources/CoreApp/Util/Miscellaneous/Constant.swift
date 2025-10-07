//
//  Constant.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

public struct Constant {
    public static let HOST = "http://192.168.1.5:8000"
    public static let API_BASE_URL: String = "\(HOST)/api/"
    public static let DATABASE_NAME = "pocket_goods_database"
    public static let DATABASE_VERSION = "v1"
    public static let DATABASE_FILE_EXTENSION = "db"
    public static let APP_CACHE_DIR = "pocket_goods_cache"
    public static let PRODUCTS_TABLE = "products_table"
    public static let WISHLIST_TABLE = "wishlist_table"
    public static let USERS_TABLE = "users_table"
    public static let IMAGES_TABLE = "images_table"
    public static let APP_SETTINGS_TABLE = "app_settings_table"
    public static let REQUEST_TIMEOUT: Double = 35
}
