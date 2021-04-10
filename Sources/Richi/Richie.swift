//
//  Richi.swift
//  Core
//
//  Created by Andreas Pfurtscheller on 07.04.21.
//

import Foundation
import AVFoundation

public struct Richi {
    
    public enum Gravity {
        case aspectFill
        case aspectFit
        case fill
    }
    
    public enum PlaybackState: Equatable, CustomStringConvertible {
        case failed(_ error: Richi.Error)
        case paused
        case playing
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
    
    public enum PausedReason: CustomStringConvertible {
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
    
    public enum BufferingState: CustomStringConvertible {
        case unknown
        case ready
        case delayed

        public var description: String {
            get {
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
    }
    
    public struct Asset: Equatable {
        public var url: URL
        public var headers: [String: String] = [:]
        
        public init(url: URL, headers: [String : String] = [:]) {
            self.url = url
            self.headers = headers
        }
    }
    
    public enum EndAction {
        // TODO: implement playlists
        // case advance
        case freeze
        case loop
        case pause
    }
    
    public enum Error: Swift.Error {
        case assetError(_ error: Swift.Error?)
        case assetNotPlayable
        case playerItemError(_ error: Swift.Error?)
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
