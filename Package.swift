// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "AcceleratedCGPoints",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "AcceleratedCGPoints",
            targets: ["AcceleratedCGPoints"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AcceleratedCGPoints",
            dependencies: []
        ),
        .testTarget(
            name: "AcceleratedCGPointsTests",
            dependencies: ["AcceleratedCGPoints"]
        ),
    ]
)
