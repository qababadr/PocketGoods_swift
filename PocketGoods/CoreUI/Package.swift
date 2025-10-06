// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/LottieFiles/dotlottie-ios.git",
            from: "0.11.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoreUI",
            dependencies: [
                .product(name: "DotLottie", package: "dotlottie-ios")
            ],
            resources: [
                .process("Media.xcassets"),
                .process("Animation/discount_offers.json"),
                .process("Animation/zero_purchase.json"),
                .process("Font"),
            ]
        )
    ]
)
