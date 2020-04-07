// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PodcastsImportTool",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "PodcastsImportTool",
            targets: ["PodcastsImportTool"]
        ),
        .library(
            name: "PodcastsImportKit",
            targets: ["PodcastsImportKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pvieito/LoggerKit.git", .branch("master")),
        .package(url: "https://github.com/pvieito/FoundationKit.git", .branch("master")),
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.10.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1")),
    ],
    targets: [
        .target(
            name: "PodcastsImportTool",
            dependencies: ["PodcastsImportKit", "LoggerKit", "FoundationKit", .product(name: "ArgumentParser", package: "swift-argument-parser")],
            path: "PodcastsImportTool"
        ),
        .target(
            name: "PodcastsImportKit",
            dependencies: ["FoundationKit", "XMLCoder"],
            path: "PodcastsImportKit"
        ),
        .testTarget(
            name: "PodcastsImportKitTests",
            dependencies: ["PodcastsImportKit", "FoundationKit"]
        )
    ]
)
