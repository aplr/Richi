<h1>
    <img src="https://raw.githubusercontent.com/aplr/Richi/main/Logo.png?token=AAIAWBDVTXVU2WU3NM5UJMDAPPZA4" height="23" />
    Richi
</h1>

![Build](https://github.com/aplr/Richi/workflows/Build/badge.svg?branch=main)
![Documentation](https://github.com/aplr/Richi/workflows/Documentation/badge.svg)

Richi is an easy-to-use media player library written in Swift, with support for iOS, tvOS and macOS.
It provides you with Video- and AudioPlayer classes, wrapping AVPlayer and making it more accessible.
Beyond that, Richi includes a subclassable VideoPlayerView with a simple yet powerful API, which makes playing videos a joy on both iOS and macOS.

## Features

Richi builds on top of AVPlayer and aims at simplifying its interface, while providing additional features such as:

► Playback events using delegates  
► Time observing using delegates and Combine  
► Built-In URL-based memory and disk cache (🚧 WIP)  
► Header-based authentication  
► Customizable asset loading  
► Video snapshots

This library does **NOT** provide any video or audio player UI in order to keep it as lightweight as possible, while making it highly flexible to use.

## Installation

Richi is available via the [Swift Package Manager](https://swift.org/package-manager/) which is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system and automates the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding Richi as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(
        url: "https://github.com/aplr/Richi.git",
        .upToNextMajor(from: "1.0.0")
    )
]
```

## Usage

```swift
import Richi

class UIViewController {

    /// The video player view
    lazy var videoPlayer: VideoPlayerView = {
        let view = VideoPlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionAtEnd = .loop
        view.gravity = .aspectFit
        view.autoplay = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the video player as a subview
        view.addSubview(videoPlayer)

        // Add layout constraints
        view.addConstraints([
            videoPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayer.topAnchor.constraint(equalTo: view.topAnchor),
            videoPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!

        let asset = Richi.Asset(url: url)

        // Load the asset. Since autoplay is enabled, playback
        // will start as soon as the asset is ready to play.
        videoPlayer.asset = asset
    }
}
```

## Documentation

Documentation is available [here](https://richi.aplr.io) and provides a comprehensive documentation of the library's public interface. Expect usage examples and guides to be added shortly. For now, have a look at the demo app in the *Example* directory.

## License
Richi is licensed under the [MIT License](https://github.com/aplr/Richi/blob/main/LICENSE).
