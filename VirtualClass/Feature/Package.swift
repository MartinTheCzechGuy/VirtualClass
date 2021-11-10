// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Login",
            targets: ["Login"]
        ),
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
        .package(path: "../Generic"),
    ],
    targets: [
        .target(
            name: "Login",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
            ]
        ),
        .testTarget(
            name: "FeatureTests",
            dependencies: ["Login"]
        ),
    ]
)
