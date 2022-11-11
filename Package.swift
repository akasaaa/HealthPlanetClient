// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HealthPlanetClient",
    products: [
        .library(name: "HealthPlanetClient", targets: ["HealthPlanetClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.18.1")
    ],
    targets: [
        .target(name: "HealthPlanetClient", dependencies: [
            .product(name: "PromiseKit", package: "PromiseKit"),
        ]),
        .testTarget(name: "HealthPlanetClientTests", dependencies: ["HealthPlanetClient"]),
    ]
)
