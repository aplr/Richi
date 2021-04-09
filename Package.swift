// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Richie",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
    ],
    products: [
        .library(
            name: "Richie",
            targets: ["Richie"]
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
            name: "Richie",
            dependencies: ["PINCache"]
        ),
        .testTarget(
            name: "RichieTests",
            dependencies: ["Richie"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
