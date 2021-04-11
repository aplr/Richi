//
//  Richi.swift
//  Core
//
//  Created by Andreas Pfurtscheller on 07.04.21.
//

import Foundation
import AVFoundation

/// This struct provides a scope for global structures and enums that need to be accessible publicly.
public struct Richi {

    /// An enum that describes how the video is displayed within a layer’s bounds rectangle.
    public enum Gravity {
        /// The player should preserve the video’s aspect ratio and fill the layer’s bounds.
        case aspectFill

        /// The player should preserve the video’s aspect ratio and fit the video within the layer’s bounds.
        case aspectFit

        /// The video should be stretched to fill the layer’s bounds.
        case fill
    }

    /// An enum that describes the playback state of the Video Player
    public enum PlaybackState: Equatable, CustomStringConvertible {
        /// The playback has failed because of the encapsulated error.
        case failed(_ error: Richi.Error)

        /// The playback has been paused
        case paused

        /// The vide is currently playing
        case playing

        /// The playback has been stopped
        case stopped

        public var description: String {
            switch self {
            case .failed(let error):
                return "Failed (\(error))"
            case .paused:
                return "Paused"
            case .playing:
                return "Playing"
            case .stopped:
                return "Stopped"
            }
        }

        var isPausable: Bool {
            switch self {
            case .paused: fallthrough
            case .playing: return true
            case .failed(_): fallthrough
            case .stopped: return false
            }
        }

        public static func == (lhs: Richi.PlaybackState, rhs: Richi.PlaybackState) -> Bool {
            switch (lhs, rhs) {
            case (.failed, .failed): return true
            case (.paused, .paused): return true
            case (.playing, .playing): return true
            case (.stopped, .stopped): return true
            default: return false
            }
        }
    }

    /// An enum that describes the current buffer state
    public enum BufferingState: CustomStringConvertible {
        /// The buffer is in an undefined state
        case unknown

        /// The video is ready to play
        case ready

        /// The playback is delayed until the buffer fills up
        case delayed

        public var description: String {
            switch self {
            case .unknown:
                return "Unknown"
            case .ready:
                return "Ready"
            case .delayed:
                return "Delayed"
            }
        }
    }

    /// A struct that models timed audiovisual media.
    public struct Asset: Equatable {
        /// Local or Remote Asset URL
        public var url: URL

        /// Headers to be sent with the request to the given URL
        public var headers: [String: String] = [:]
        
        /// Mime type of the asset
        public var mimeType: String? = nil

        /// Creates a new asset object that models the media at the specified URL.
        ///
        /// - Parameters:
        ///   - url: A URL to a local, remote, or HTTP Live Streaming media resource.
        ///   - headers: Headers to be sent with the request to the given URL
        ///   - mimeType: Mime type of the asset
        public init(
            url: URL,
            headers: [String : String] = [:],
            mimeType: String? = nil
        ) {
            self.url = url
            self.headers = headers
            self.mimeType = mimeType
        }
    }

    /// The actions a player can take when it finishes playing.
    public enum EndAction {
        // TODO: implement playlists
        // /// The player should advance to the next item, if there is one.
        // case advance

        /// The player should freeze at the end
        case freeze

        /// The player should loop the video.
        case loop

        /// The player should pause playing.
        case pause
    }

    /// This enum is used for all errors that are generated by this library.
    /// Any external errors are wrapped within more descriptive ones.
    public enum Error: Swift.Error {
        /// The player could not play the current asset
        case assetError(_ error: Swift.Error?)

        /// The given asset is not playable because of an undisclosed reason
        case assetNotPlayable

        /// The player could not play the current item
        case playerItemError(_ error: Swift.Error?)
    }

    enum PausedReason: CustomStringConvertible {
        case backgrounded
        case interrupted
        case stopped
        case userInteraction
        case waitKeepUp

        public var description: String {
            switch self {
            case .backgrounded: return "Backgrounded"
            case .interrupted: return "Interrupted"
            case .stopped: return "Stopped"
            case .userInteraction: return "User interaction"
            case .waitKeepUp: return "Waiting to keep up"
            }
        }
    }
}

extension Richi.Error: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .assetError(let error):
            return error?.localizedDescription ?? NSLocalizedString("asset.error.generic", comment: "")
        case .assetNotPlayable:
            return NSLocalizedString("asset.error.notPlayable", comment: "")
        case .playerItemError(let error):
            return error?.localizedDescription ?? NSLocalizedString("playerItem.error.generic", comment: "")
        }
    }
}
