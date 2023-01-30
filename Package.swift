// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SpotifyiOS",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SpotifyiOS",
            targets: ["SpotifyiOS"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "SpotifyiOS",
            path: "SpotifyiOS.xcframework"
        )
    ]
)
