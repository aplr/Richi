//
//  MediaPlayer+Delegates.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 10.04.21.
//

import Foundation


/// A set of methods which allow to respond to media player events.
public protocol MediaPlayerDelegate: AnyObject {
    /// Tells the delegate that the media player is ready to play assets.
    ///
    /// - Parameter player: The player object
    func playerReady(_ player: MediaPlayer)

    /// Tells the delegate that the internal playback state of the media player has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - oldState: The previous state the player transitioned from
    ///   - newState: The new state the player transitioned to
    func player(
        _ player: MediaPlayer,
        didChangePlaybackStateFrom oldState: Richi.PlaybackState,
        to newState: Richi.PlaybackState
    )
    
    /// Tells the delegate that the internal buffering state of the media player has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - oldState: The previous state the player transitioned from
    ///   - newState: The new state the player transitioned to
    func player(
        _ player: MediaPlayer,
        didChangeBufferingStateFrom oldState: Richi.BufferingState,
        to newState: Richi.BufferingState
    )
    
    /// Tells the delegate that the buffering time has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - bufferTime: The time in seconds that the media has been buffered.
    func player(_ player: MediaPlayer, didChangeBufferTime bufferTime: Double)
    
    /// Tells the delegate that the player did fail with the given error.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - error: The underlying error
    func player(_ player: MediaPlayer, didFailWithError error: Richi.Error)

    /// Tells the delegate that the player has loaded the asset.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - asset: The media asset which has been loaded
    func player(_ player: MediaPlayer, didLoadAsset asset: Richi.Asset)
    
    /// Tells the delegate that the playback of the current item did end.
    ///
    /// - Parameter player: The player object
    func playerDidEnd(_ player: MediaPlayer)
    
    /// Tells the delegate that the playback did play to end time.
    ///
    /// - Parameter player: The player object
    func playerDidPlayToEnd(_ player: MediaPlayer)
    
    /// Tells the delegate that the playback of the current item is about to loop.
    ///
    /// - Parameter player: The player object
    func playerWillLoop(_ player: MediaPlayer)
    
    /// Tells the delegate that the playback of the current item did loop.
    ///
    /// - Parameter player: The player object
    func playerDidLoop(_ player: MediaPlayer)
}

/// A set of methods which allow to respond to media player time changes.
public protocol MediaPlayerTimeDelegate: AnyObject {
    /// Tells the delegate that the playback time of the current asset has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - time: The time in seconds that the media playback has progressed.
    func player(_ player: MediaPlayer, didChangeCurrentTime time: TimeInterval)
}

public extension MediaPlayerDelegate {
    
    func playerReady(_ player: MediaPlayer) {
        
    }
    
    func player(
        _ player: MediaPlayer,
        didChangePlaybackStateFrom oldState: Richi.PlaybackState,
        to newState: Richi.PlaybackState
    ) {
        
    }
    
    func player(
        _ player: MediaPlayer,
        didChangeBufferingStateFrom oldState: Richi.BufferingState,
        to newState: Richi.BufferingState
    ) {
        
    }
    
    func player(_ player: MediaPlayer, didChangeBufferTime bufferTime: Double) {
        
    }
    
    func player(_ player: MediaPlayer, didFailWithError error: Richi.Error) {
        
    }
    
    func player(_ player: MediaPlayer, didLoadAsset asset: Richi.Asset) {
        
    }
    
    func playerDidEnd(_ player: MediaPlayer) {
        
    }
    
    func playerDidPlayToEnd(_ player: MediaPlayer) {
        
    }
    
    func playerWillLoop(_ player: MediaPlayer) {
        
    }
    
    func playerDidLoop(_ player: MediaPlayer) {
        
    }
    
}

public extension MediaPlayerTimeDelegate {
    
    func player(_ player: MediaPlayer, didChangeCurrentTime time: TimeInterval) {
        
    }
    
}
