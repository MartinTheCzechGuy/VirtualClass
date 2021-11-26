// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Generic",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "UserSDK",
            targets: ["UserSDK"]
        ),
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "UserSDK",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
                .product(name: "Database", package: "Infrastructure"),
                .product(name: "SecureStorage", package: "Infrastructure"),
                .product(name: "BasicLocalStorage", package: "Infrastructure"),
                "CombineExt"
            ]
        ),
        .testTarget(
            name: "UserSDKTests",
            dependencies: ["UserSDK"]
        ),
    ]
)
