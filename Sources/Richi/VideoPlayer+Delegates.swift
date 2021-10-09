//
//  VideoPlayerView+Delegates.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 10.04.21.
//

import Foundation

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif


/// A set of methods which allow to respond to video player events.
public protocol VideoPlayerDelegate: AnyObject {
    /// Tells the delegate that the video player is ready to play assets.
    ///
    /// - Parameter player: The player object
    func playerReady(_ player: VideoPlayer)

    /// Tells the delegate that the internal playback state of the video player has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - oldState: The previous state the player transitioned from
    ///   - newState: The new state the player transitioned to
    func player(_ player: VideoPlayer, didChangePlaybackStateFrom oldState: Richi.PlaybackState, to newState: Richi.PlaybackState)
    
    /// Tells the delegate that the internal buffering state of the video player has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - oldState: The previous state the player transitioned from
    ///   - newState: The new state the player transitioned to
    func player(_ player: VideoPlayer, didChangeBufferingStateFrom oldState: Richi.BufferingState, to newState: Richi.BufferingState)
    
    /// Tells the delegate that the buffering time has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - bufferTime: The time in seconds that the video has been buffered.
    func player(_ player: VideoPlayer, didChangeBufferTime bufferTime: Double)
    
    /// Tells the delegate that the player did fail with the given error.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - error: The underlying error
    func player(_ player: VideoPlayer, didFailWithError error: Richi.Error)

    /// Tells the delegate that the player has loaded the asset.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - asset: The video asset which has been loaded
    func player(_ player: VideoPlayer, didLoadAsset asset: Richi.Asset)
    
    /// Tells the delegate that the video size of the current asset has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - size: The video asset's size
    func player(_ player: VideoPlayer, didChangeVideoSize size: CGSize)
    
    /// Tells the delegate that the playback of the current item did end.
    ///
    /// - Parameter player: The player object
    func playerDidEnd(_ player: VideoPlayer)
    
    /// Tells the delegate that the playback did play to end time.
    ///
    /// - Parameter player: The player object
    func playerDidPlayToEnd(_ player: VideoPlayer)
    
    /// Tells the delegate that the playback of the current item is about to loop.
    ///
    /// - Parameter player: The player object
    func playerWillLoop(_ player: VideoPlayer)
    
    /// Tells the delegate that the playback of the current item did loop.
    ///
    /// - Parameter player: The player object
    func playerDidLoop(_ player: VideoPlayer)
}

/// A set of methods which allow to respond to video player time changes.
public protocol VideoPlayerTimeDelegate: AnyObject {
    /// Tells the delegate that the playback time of the current asset has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - time: The time in seconds that the video playback has progressed.
    func player(_ player: VideoPlayer, didChangeCurrentTime time: TimeInterval)
}

public extension VideoPlayerDelegate {
    
    func playerReady(_ player: VideoPlayer) {
        
    }
    
    func player(_ player: VideoPlayer, didChangePlaybackStateFrom oldState: Richi.PlaybackState, to newState: Richi.PlaybackState) {
        
    }
    
    func player(_ player: VideoPlayer, didChangeBufferingStateFrom oldState: Richi.BufferingState, to newState: Richi.BufferingState) {
        
    }
    
    func player(_ player: VideoPlayer, didChangeBufferTime bufferTime: Double) {
        
    }
    
    func player(_ player: VideoPlayer, didFailWithError error: Richi.Error) {
        
    }
    
    func player(_ player: VideoPlayer, didLoadAsset asset: Richi.Asset) {
        
    }
    
    func player(_ player: VideoPlayer, didChangeVideoSize size: CGSize) {
        
    }
    
    func playerDidEnd(_ player: VideoPlayer) {
        
    }
    
    func playerDidPlayToEnd(_ player: VideoPlayer) {
        
    }
    
    func playerWillLoop(_ player: VideoPlayer) {
        
    }
    
    func playerDidLoop(_ player: VideoPlayer) {
        
    }
    
}

public extension VideoPlayerTimeDelegate {
    
    func player(_ player: VideoPlayer, didChangeCurrentTime time: TimeInterval) {
        
    }
    
}
