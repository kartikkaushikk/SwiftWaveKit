// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WaveKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "WaveKit",
            targets: ["WaveKit"]
        ),
        .library(
            name: "WaveKitExampleUI",
            targets: ["WaveKitExampleUI"]
        ),
        .executable(
            name: "WaveKitExample",
            targets: ["WaveKitExample"]
        ),
    ],
    targets: [
        .target(
            name: "WaveKit",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
        .target(
            name: "WaveKitExampleUI",
            dependencies: ["WaveKit"],
            path: "Example/WaveKitExampleUI"
        ),
        .executableTarget(
            name: "WaveKitExample",
            dependencies: ["WaveKitExampleUI"],
            path: "Example/WaveKitExample"
        ),
        .testTarget(
            name: "WaveKitTests",
            dependencies: ["WaveKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
