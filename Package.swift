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
              url: "https://github.com/achinwo/SpotifyiOS/releases/download/1.3.3/SpotifyiOS.xcframework.zip",
              checksum: "061fdb53f602f0da367931b04fd1d199e3639cb040e72bb10308ae3e8d96f4d1"
        )
    ]
)
