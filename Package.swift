// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "XUI",
    platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v8), .tvOS(.v15)],
    products: [
        .library(
            name: "XUI",
            targets: ["XUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "XUI",
            dependencies: []),
        .testTarget(
            name: "XUITests",
            dependencies: ["XUI"]),
    ]
)
