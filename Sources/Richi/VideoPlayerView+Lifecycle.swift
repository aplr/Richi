//
//  VideoPlayerView+Lifecycle.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 09.04.21.
//


#if os(macOS)
import AppKit
#else
import UIKit
#endif

import Foundation

#if os(macOS)
fileprivate var WillResignActiveNotificationName = NSApplication.willResignActiveNotification
fileprivate var DidBecomeActiveNotificationName = NSApplication.didBecomeActiveNotification
fileprivate var DidEnterBackgroundNotificationName = NSApplication.didHideNotification
fileprivate var WillEnterForegroundNotificationName = NSApplication.willUnhideNotification
#else
fileprivate var WillResignActiveNotificationName = UIApplication.willResignActiveNotification
fileprivate var DidBecomeActiveNotificationName = UIApplication.didBecomeActiveNotification
fileprivate var DidEnterBackgroundNotificationName = UIApplication.didEnterBackgroundNotification
fileprivate var WillEnterForegroundNotificationName = UIApplication.willEnterForegroundNotification
#endif

extension VideoPlayer {
    
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
        if self.playbackState == .playing && self.pauseWhenResigningActive {
            self.pause()
        }
    }
    
    @objc private func handleApplicationDidBecomeActive(_ notification: Notification) {
        if self.playbackState == .paused && self.resumeWhenBecomingActive {
            self.playIfPossible()
        }
    }
    
    @objc private func handleApplicationDidEnterBackground(_ notification: Notification) {
        if self.playbackState == .playing && self.pauseWhenEnteringBackground {
            self.pause()
        }
    }
    
    @objc private func handleApplicationWillEnterForeground(_ notification: Notification) {
        if self.playbackState == .paused && self.resumeWhenEnteringForeground {
            self.playIfPossible()
        }
    }
    
}
