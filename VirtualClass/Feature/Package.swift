// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Feature",
            targets: ["Feature"]
        ),
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
        .package(path: "../Generic"),
    ],
    targets: [
        .target(
            name: "Feature",
            dependencies: []
        ),
        .testTarget(
            name: "FeatureTests",
            dependencies: ["Feature"]
        ),
    ]
)
