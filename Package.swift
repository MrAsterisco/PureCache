// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "PureCache",
    platforms: [
      .macOS(.v10_12),
      .iOS(.v9),
      .macCatalyst(.v13),
      .tvOS(.v9),
      .watchOS(.v2)
    ],
    products: [
        .library(
            name: "PureCache",
            targets: ["PureCache"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PureCache",
            dependencies: []),
        .testTarget(
            name: "PureCacheTests",
            dependencies: ["PureCache"]),
    ]
)
