//
//  VideoPlayer+Observers.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

import Foundation
import AVFoundation

extension VideoPlayer {
    
    override func addPlayerItemObservers(to playerItem: AVPlayerItem) {
        super.addPlayerItemObservers(to: playerItem)
        
        playerItemObservers.append(
            playerItem.observe(\.presentationSize, options: [.new, .old], changeHandler: { [weak self] (playerItem, change) in
                guard let self = self, let delegate = self as? VideoPlayerDelegate else { return }
                
                self.runOnMainLoop {
                    delegate.player(self, didChangePresentationSize: change.newValue ?? .zero)
                }
            })
        )
    }
}
