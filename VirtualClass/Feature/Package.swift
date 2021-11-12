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
            name: "SharedFeatures",
            targets: ["SharedFeatures"]
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
                "SharedFeatures"
            ]
        ),
        .target(
            name: "Calendar",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
                "SharedFeatures"
            ]
        ),
        .target(
            name: "Classes",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
                "SharedFeatures"
            ]
        ),
        .target(
            name: "SharedFeatures",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
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
                "SharedFeatures",
                "Classes"
            ]
        ),
        .testTarget(
            name: "FeatureTests",
            dependencies: ["Auth"]
        ),
    ]
)
