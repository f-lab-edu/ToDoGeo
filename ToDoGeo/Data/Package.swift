// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.9.1")),
        .package(name: "Shared", path: "../Shared"),
        .package(name: "Domain", path: "../Domain"),
        .package(name: "GeoLocationManager", path: "../GeoLocationManager"),
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Shared", package: "Shared"),
                .product(name: "GeoLocationManager", package: "GeoLocationManager"),
                .product(name: "Alamofire", package: "Alamofire")
            ]),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"]),
    ]
)
