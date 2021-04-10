// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Richi",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "Richi",
            targets: ["Richi"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pinterest/PINCache.git",
            from: "3.0.3"
        ),
    ],
    targets: [
        .target(
            name: "Richi",
            dependencies: ["PINCache"]
        ),
        .testTarget(
            name: "RichiTests",
            dependencies: ["Richi"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
