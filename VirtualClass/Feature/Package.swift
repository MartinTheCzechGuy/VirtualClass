// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Auth",
            targets: ["Auth"]
        ),
        .library(
            name: "Calendar",
            targets: ["Calendar"]
        ),
        .library(
            name: "Classes",
            targets: ["Classes"]
        ),
        .library(
            name: "Dashboard",
            targets: ["Dashboard"]
        ),
        .library(
            name: "UserAccount",
            targets: ["UserAccount"]
        ),
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
        .package(path: "../Generic"),
    ],
    targets: [
        .target(
            name: "Auth",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
                .product(name: "Common", package: "Infrastructure"),
                .product(name: "UserSDK", package: "Generic"),
            ]
        ),
        .target(
            name: "Calendar",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
                .product(name: "Common", package: "Infrastructure"),
            ]
        ),
        .target(
            name: "Classes",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
                .product(name: "Common", package: "Infrastructure"),
            ]
        ),
        .target(
            name: "Dashboard",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
                "Calendar",
                "Classes",
                "UserAccount"
            ]
        ),
        .target(
            name: "UserAccount",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
                .product(name: "Common", package: "Infrastructure"),
                .product(name: "UserSDK", package: "Generic"),
                "Classes",
            ]
        ),
        .testTarget(
            name: "FeatureTests",
            dependencies: ["Auth"]
        ),
    ]
)
