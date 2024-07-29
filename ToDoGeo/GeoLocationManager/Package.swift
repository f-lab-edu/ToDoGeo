// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GeoLocationManager",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GeoLocationManager",
            targets: ["GeoLocationManager"]),
    ],
    dependencies: [
        .package(name: "Shared", path: "../Shared"),
    ],
    targets: [
        .target(
            name: "GeoLocationManager",
            dependencies: [
                .product(name: "Shared", package: "Shared"),
            ]),
        .testTarget(
            name: "GeoLocationManagerTests",
            dependencies: ["GeoLocationManager"]),
    ]
)
