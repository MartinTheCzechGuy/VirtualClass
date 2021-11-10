// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Generic",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Generic",
            targets: ["Generic"]
        ),
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
    ],
    targets: [
        .target(
            name: "Generic",
            dependencies: []
        ),
        .testTarget(
            name: "GenericTests",
            dependencies: ["Generic"]
        ),
    ]
)
