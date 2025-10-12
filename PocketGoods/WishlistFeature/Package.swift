// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WishlistFeature",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WishlistFeature",
            targets: ["WishlistFeature"]
        )
    ],
    dependencies: [
        .package(name: "CoreApp", path: "../CoreApp"),
        .package(name: "CoreUI", path: "../CoreUI"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WishlistFeature",
            dependencies: [
                "CoreApp",
                "CoreUI",
            ]
        ),
        .testTarget(
            name: "WishlistFeatureTests",
            dependencies: ["WishlistFeature"]
        ),
    ]
)
