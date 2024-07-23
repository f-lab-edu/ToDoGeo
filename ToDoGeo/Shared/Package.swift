// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shared",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Shared",
            targets: ["Shared"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Shared"),
        .testTarget(
            name: "SharedTests",
            dependencies: ["Shared"]),
    ]
)
