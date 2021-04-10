//
//  VideoPlayerView+Delegates.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 10.04.21.
//

import Foundation


/// Player delegate protocol
public protocol VideoPlayerDelegate: AnyObject {
    func playerReady(_ player: VideoPlayer)
    
    func player(_ player: VideoPlayer, didChangePlaybackStateFrom oldState: Richi.PlaybackState, to newState: Richi.PlaybackState)
    func player(_ player: VideoPlayer, didChangeBufferingStateFrom oldState: Richi.BufferingState, to newState: Richi.BufferingState)

    // This is the time in seconds that the video has been buffered.
    // If implementing a UIProgressView, user this value / player.maximumDuration to set progress.
    func player(_ player: VideoPlayer, didChangeBufferTime bufferTime: Double)

    func player(_ player: VideoPlayer, didFailWithError error: Richi.Error)
    
    func player(_ player: VideoPlayer, didLoadAsset asset: Richi.Asset)
    func playerWillStartFromBeginning(_ player: VideoPlayer)
    func playerDidEnd(_ player: VideoPlayer)
    func playerWillLoop(_ player: VideoPlayer)
    func playerDidLoop(_ player: VideoPlayer)
}

public protocol VideoPlayerTimeDelegate: AnyObject {
    func player(_ player: VideoPlayer, didChangeCurrentTime time: TimeInterval)
}

extension VideoPlayerDelegate {
    
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
    
    func playerWillStartFromBeginning(_ player: VideoPlayer) {
        
    }
    
    func playerDidEnd(_ player: VideoPlayer) {
        
    }
    
    func playerWillLoop(_ player: VideoPlayer) {
        
    }
    
    func playerDidLoop(_ player: VideoPlayer) {
        
    }
    
}

extension VideoPlayerTimeDelegate {
    
    func player(_ player: VideoPlayer, didChangeCurrentTime time: TimeInterval) {
        
    }
    
}
