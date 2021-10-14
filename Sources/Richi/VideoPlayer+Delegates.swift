//
//  VideoPlayer+Delegates.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import Foundation

public protocol VideoPlayerDelegate: MediaPlayerDelegate {
    
    /// Tells the delegate that the media player layer is ready to display.
    ///
    /// - Parameter player: The player object
    func playerReadyForDisplay(_ player: MediaPlayer)
    
    /// Tells the delegate that the presentation size of the current asset has changed.
    ///
    /// - Parameters:
    ///   - player: The player object
    ///   - size: The video asset's size
    func player(_ player: MediaPlayer, didChangePresentationSize size: CGSize)
    
}

public extension VideoPlayerDelegate {
    
    func playerReadyForDisplay(_ player: MediaPlayer) {
        
    }
    
    func player(_ player: MediaPlayer, didChangePresentationSize size: CGSize) {
        
    }
    
}
