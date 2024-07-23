// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Domain",
            targets: ["Domain"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "10.25.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.6.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Domain",
            dependencies: [
                           .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                           .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
                           .product(name: "FirebaseDatabaseSwift", package: "firebase-ios-sdk"),
                           .product(name: "RxSwift", package: "RxSwift"),
                           .product(name: "RxCocoa", package: "RxSwift")
                       ]),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]),
    ]
)
