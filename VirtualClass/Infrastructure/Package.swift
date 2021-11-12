// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "InstanceProvider",
            targets: ["InstanceProvider"]
        ),
        .library(
            name: "Database",
            targets: ["Database"]
        ),
        .library(
            name: "BasicLocalStorage",
            targets: ["BasicLocalStorage"]
        ),
        .library(
            name: "Common",
            targets: ["Common"]
        ),
        .library(
            name: "SecureStorage",
            targets: ["SecureStorage"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Qase/swift-core-database", .revisionItem("a838454a720ce8eb77c0be6339d0bd8a1ba735cf")),
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMajor(from: "2.7.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "InstanceProvider",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration"
            ]
        ),
        .target(
            name: "Database",
            dependencies: [
                .product(name: "CoreDatabase", package: "swift-core-database"),
                "Common",
                "Swinject",
                "SwinjectAutoregistration"
            ]
        ),
        .target(
            name: "Common",
            dependencies: []
        ),
        .target(
            name: "BasicLocalStorage",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration"
            ]
        ),
        .target(
            name: "SecureStorage",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration"
            ]
        ),
        .testTarget(
            name: "InfrastructureTests",
            dependencies: ["BasicLocalStorage", "Database", "InstanceProvider", "SecureStorage"]
        ),
    ]
)
