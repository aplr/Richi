//
//  AudioPlayer.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

import Foundation

public class AudioPlayer: MediaPlayer {
    
    /// The object that acts as the delegate of the video player view
    open weak var delegate: MediaPlayerDelegate? {
        get { _delegate }
        set { _delegate = newValue }
    }
    
}
