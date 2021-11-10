// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppStart",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AppStart",
            targets: ["AppStart"]
        ),
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
        .package(path: "../Generic"),
        .package(path: "../Feature"),
    ],
    targets: [
        .target(
            name: "AppStart",
            dependencies: []
        ),
        .testTarget(
            name: "AppStartTests",
            dependencies: ["AppStart"]
        ),
    ]
)
