//
//  MediaPlayer+Lifecycle.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 09.04.21.
//


#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import Foundation

#if canImport(AppKit)
fileprivate var WillResignActiveNotificationName = NSApplication.willResignActiveNotification
fileprivate var DidBecomeActiveNotificationName = NSApplication.didBecomeActiveNotification
fileprivate var DidEnterBackgroundNotificationName = NSApplication.didHideNotification
fileprivate var WillEnterForegroundNotificationName = NSApplication.willUnhideNotification
#elseif canImport(UIKit)
fileprivate var WillResignActiveNotificationName = UIApplication.willResignActiveNotification
fileprivate var DidBecomeActiveNotificationName = UIApplication.didBecomeActiveNotification
fileprivate var DidEnterBackgroundNotificationName = UIApplication.didEnterBackgroundNotification
fileprivate var WillEnterForegroundNotificationName = UIApplication.willEnterForegroundNotification
#endif


extension MediaPlayer {
    
    func addLifecycleObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleApplicationWillResignActive(_:)),
            name: WillResignActiveNotificationName,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleApplicationDidBecomeActive(_:)),
            name: DidBecomeActiveNotificationName,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleApplicationDidEnterBackground(_:)),
            name: DidEnterBackgroundNotificationName,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleApplicationWillEnterForeground(_:)),
            name: WillEnterForegroundNotificationName,
            object: nil
        )
    }
    
    func removeLifecycleObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: WillResignActiveNotificationName,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: DidBecomeActiveNotificationName,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: DidEnterBackgroundNotificationName,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: WillEnterForegroundNotificationName,
            object: nil
        )
    }
    
    @objc private func handleApplicationWillResignActive(_ notification: Notification) {
        // Pause the playback and note the pause reason if the application was
        // interrupted temporarily and the corresponding flag is set to `true`
        if playbackState.isPausable, pauseWhenResigningActive {
            pause(reason: .interrupted)
        }
    }
    
    @objc private func handleApplicationDidBecomeActive(_ notification: Notification) {
        // Resume playback if the player was paused because of a temporary
        // interruption and the corresponding flag is set
        if playbackState == .paused, pausedReason == .interrupted, resumeWhenBecomingActive {
            autoPlay()
        }
    }
    
    @objc private func handleApplicationDidEnterBackground(_ notification: Notification) {
        // Pause the playback and note the pause reason if the application enters background,
        // the player is playing or was interrupted and the corresponding flag is set
        if playbackState.isPausable, pauseWhenEnteringBackground {
            pause(reason: .backgrounded)
        }
    }
    
    @objc private func handleApplicationWillEnterForeground(_ notification: Notification) {
        // Resume playback if the player was paused because the application was
        // sent to background before and the corresponding flag is set
        if playbackState == .paused, pausedReason == .backgrounded, resumeWhenEnteringForeground {
            autoPlay()
        }
    }
    
}
