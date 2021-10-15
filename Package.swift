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
    dependencies: [],
    targets: [
        .target(
            name: "Richi",
            dependencies: []
        ),
        .testTarget(
            name: "RichiTests",
            dependencies: ["Richi"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
