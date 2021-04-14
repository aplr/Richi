//
//  VideoPlayerView+Observers.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 09.04.21.
//

import Foundation
import AVFoundation


// MARK: - Player Observers

extension VideoPlayer {
        
    private func removeInternalTimeObserver() {
        guard let playerTimeObserver = playerTimeObserver else { return }
        
        removeTimeObserver(playerTimeObserver)
        self.playerTimeObserver = nil
    }
    
    func updateInternalTimeObserver() {
        // Remove any old observer
        removeInternalTimeObserver()
        
        // Don't set up a new observer if we have no delegate listening
        guard timeDelegate != nil else { return }
        
        // Create a new periodic time observer
        let interval = CMTime(seconds: timeObserverInterval, preferredTimescale: 1000)
        playerTimeObserver = addPeriodicTimeObserver(forInterval: interval, using: { [weak self] time in
            guard let self = self else { return }
            
            self.timeDelegate?.player(self, didChangeCurrentTime: time.seconds)
        })
    }
    
    func addPlayerObservers() {
        playerObservers.append(
            player.observe(\.timeControlStatus, options: [.new, .old]) { [weak self] (object, change) in
                switch object.timeControlStatus {
                case .paused:
                    self?.playbackState = .paused
                case .playing:
                    self?.playbackState = .playing
                case .waitingToPlayAtSpecifiedRate:
                    fallthrough
                @unknown default:
                    break
                }
            }
        )
    }
    
    func removePlayerObservers() {
        removeInternalTimeObserver()
        playerObservers.invalidateAll()
        playerObservers.removeAll()
    }
}


// MARK: - Player Item Observers

extension VideoPlayer {
    
    func addPlayerItemObservers(to playerItem: AVPlayerItem) {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidPlayToEndTime(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemFailedToPlayToEndTime(_:)),
            name: .AVPlayerItemFailedToPlayToEndTime,
            object: playerItem
        )
        
        playerItemObservers.append(
            playerItem.observe(\.status, options: [.new, .old], changeHandler: { [weak self] (playerItem, change) in
                guard let self = self else { return }
                
                if playerItem.status == .failed {
                    self.playbackState = .failed(.playerItemError(playerItem.error))
                } else if playerItem.status == .readyToPlay, let asset = self.asset {
                    self.playbackState = .stopped
                    self.runOnMainLoop {
                        self.delegate?.player(self, didLoadAsset: asset)
                    }
                }
            })
        )

        playerItemObservers.append(
            playerItem.observe(\.isPlaybackBufferEmpty, options: [.new, .old]) { [weak self] (playerItem, change) in
                if playerItem.isPlaybackBufferEmpty {
                    self?.bufferingState = .delayed
                }
            }
        )

        playerItemObservers.append(
            playerItem.observe(\.isPlaybackLikelyToKeepUp, options: [.new, .old]) { [weak self] (playerItem, change) in
                guard let self = self else { return }

                if playerItem.isPlaybackLikelyToKeepUp {
                    self.bufferingState = .ready
                    if self.playbackState == .playing {
                        self.play()
                    }
                }
            }
        )

        playerItemObservers.append(
            playerItem.observe(\.loadedTimeRanges, options: [.new, .old]) { [weak self] (playerItem, change) in
                guard let self = self else { return }

                self.bufferDidChange()
            }
        )
        
        playerItemObservers.append(
            playerItem.observe(\.presentationSize, options: [.new, .old], changeHandler: { [weak self] (playerItem, change) in
                guard let self = self else { return }
                
                self.runOnMainLoop {
                    self.delegate?.player(self, didChangeVideoSize: change.newValue ?? .zero)
                }
            })
        )
    }
    
    @objc private func playerItemDidPlayToEndTime(_ notification: Notification) {
        guard (notification.object as? AVPlayerItem) == player.currentItem else {
            return
        }
        
        runOnMainLoop(didPlayToEndTime)
    }
    
    @objc private func playerItemFailedToPlayToEndTime(_ notification: Notification) {
        let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? NSError
        playbackState = .failed(.playerItemError(error))
    }

    func removePlayerItemObservers() {
        if let playerItem = playerItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: playerItem)
        }
        
        playerItemObservers.invalidateAll()
        playerItemObservers.removeAll()
    }
    
    func bufferDidChange() {
        guard let playerItem = playerItem else { return }
        
        let timeRanges = playerItem.loadedTimeRanges
        
        if let timeRange = timeRanges.first?.timeRangeValue {
            let bufferedTime = (timeRange.start + timeRange.duration).seconds
            if _lastBufferTime != bufferedTime {
                _lastBufferTime = bufferedTime
                self.runOnMainLoop {
                    self.delegate?.player(self, didChangeBufferTime: bufferedTime)
                }
            }
        }

        if playerItem.isPlaybackLikelyToKeepUp, pausedReason == .waitKeepUp {
            self.autoPlay()
        }
    }
    
    func didPlayToEndTime() {
        if actionAtEnd == .loop {
            // Notify the delegate that the player is about to loop
            delegate?.playerWillLoop(self)
            // Seek to the start and play
            playFromBeginning()
            // Notify the delegate that the player has looped
            delegate?.playerDidLoop(self)
        } else if actionAtEnd == .freeze {
            // Stop playing at the end
            stop()
        } else {
            // Seek to the start and stop
            player.seek(to: .zero) { _ in self.stop() }
        }
    }
}

// MARK: - Player Layer Observers

extension VideoPlayer {
    
    func addPlayerLayerObservers() {
        playerLayerObserver = playerLayer.observe(\.isReadyForDisplay, options: [.new, .old]) { [weak self] (object, change) in
            guard let self = self else { return }
            
            self.runOnMainLoop {
                self.delegate?.playerReady(self)
            }
        }
    }

    func removePlayerLayerObservers() {
        playerLayerObserver?.invalidate()
        playerLayerObserver = nil
    }
}
