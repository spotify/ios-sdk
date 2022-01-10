// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SpotifyiOS",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SpotifyiOS",
            targets: ["SpotifyiOS"])
    ],
    dependencies: [
        // No dependencies!
    ],
    targets: [
        .binaryTarget(
            name: "SpotifyiOS",
            path: "SpotifyiOS.xcframework"
        )
    ]
)
