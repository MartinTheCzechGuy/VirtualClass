// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Generic",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "UserProfileUseCases",
            targets: ["UserProfileUseCases"]
        ),
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
    ],
    targets: [
        .target(
            name: "UserProfileUseCases",
            dependencies: [
                .product(name: "InstanceProvider", package: "Infrastructure"),
                .product(name: "Database", package: "Infrastructure"),
            ]
        ),
        .testTarget(
            name: "GenericTests",
            dependencies: ["UserProfileUseCases"]
        ),
    ]
)
