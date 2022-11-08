// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HealthPlanetClient",
    products: [
        .library(name: "HealthPlanetClient", targets: ["HealthPlanetClient"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "HealthPlanetClient", dependencies: []),
        .testTarget(name: "HealthPlanetClientTests", dependencies: ["HealthPlanetClient"]),
    ]
)
