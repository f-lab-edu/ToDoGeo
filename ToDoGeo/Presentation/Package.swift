// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]),
    ],
    dependencies: [
        .package(name: "Shared", path: "../Shared"),
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Data", path: "../Data"),
        .package(url: "https://github.com/ReactorKit/ReactorKit", .upToNextMajor(from: "3.2.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxFlow.git", .upToNextMajor(from: "2.10.0")),
        .package(url: "https://github.com/layoutBox/PinLayout", .upToNextMajor(from: "1.10.5")),
        
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: [
                .product(name: "Data", package: "Data"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "Shared", package: "Shared"),
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "RxFlow", package: "RxFlow"),
                .product(name: "PinLayout", package: "PinLayout"),
            ]),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]),
    ]
)
