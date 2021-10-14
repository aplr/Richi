//
//  MediaPlayer.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

import Foundation
import AVFoundation

public class MediaPlayer {
    
    // MARK: - Public Properties
    
    /// Determines if the media should autoplay
    open var autoplay: Bool = true
    
    /// The audio playback volume for the player.
    open var volume: Float {
        get { player.volume }
        set { player.volume = newValue }
    }
    
    /// A Boolean value that indicates whether the audio output of the player is muted.
    open var isMuted: Bool {
        get { player.isMuted }
        set { player.isMuted = newValue }
    }
    
    /// A boolean value that indicates whether media playback is playing
    open var isPlaying: Bool {
        get { playbackState == .playing }
        set { play(newValue) }
    }
    
    /// The current playback rate
    open var rate: Float = 1 {
        didSet {
            player.rate = rate
        }
    }
    
    /// The action to perform when the current player item has finished playing.
    open var actionAtEnd: Richi.EndAction = .pause
    
    // MARK: - Control Lifecycle Behavior

    /// Controls if playback is paused when the application is no longer active.
    /// This is because of temporary interruptions such as incoming phone calls,
    /// messages or when the app is backgrounded by the user.
    open var pauseWhenResigningActive: Bool = true

    /// Controls if playback is paused when the application enters the background.
    /// This is triggered by the user sending the app to the background or locking the device.
    open var pauseWhenEnteringBackground: Bool = true

    /// Controls if playback is resumed when the application has become active.
    /// Playback will be resumed only if the player was paused because of some temporary interruption.
    open var resumeWhenBecomingActive: Bool = false

    /// Controls if playback is resumed when the application is about to enter the foreground
    open var resumeWhenEnteringForeground: Bool = false
    
    /// The current asset
    open var asset: Richi.Asset? {
        didSet {
            _load(asset: asset, oldAsset: oldValue)
        }
    }
    
    /// Current playback state of the Player
    open internal(set) var playbackState: Richi.PlaybackState = .stopped {
        didSet {
            if playbackState != oldValue {
                runOnMainLoop { self.playbackStateDidChange(from: oldValue) }
            }
        }
    }
    
    /// Current buffering state of the Player
    open internal(set) var bufferingState: Richi.BufferingState = .unknown {
        didSet {
            if bufferingState != oldValue {
                runOnMainLoop { self.bufferingStateDidChange(from: oldValue) }
            }
        }
    }
    
    /// Maximum duration of playback.
    open var duration: TimeInterval {
        guard let playerItem = playerItem else {
            return CMTime.indefinite.seconds
        }

        return playerItem.duration.seconds
    }
    
    /// Media playback's current time.
    open var currentTime: CMTime {
        guard let playerItem = playerItem else {
            return .indefinite
        }

        return playerItem.currentTime()
    }
    
    /// Indicates the desired limit of network bandwidth consumption for this item.
    open var preferredPeakBitRate: Double {
        get { playerItem?.preferredPeakBitRate ?? 0 }
        set {
            playerItem?.preferredPeakBitRate = newValue
            _preferredPeakBitRate = newValue
        }
    }
    
    /// Media playback's current time interval in seconds.
    open var currentDuration: TimeInterval {
        currentTime.seconds
    }
    
    /// The object that acts as the delegate of the media player
    weak var _delegate: MediaPlayerDelegate?

    /// The object that acts as the time delegate of the audio player view
    open weak var timeDelegate: MediaPlayerTimeDelegate? {
        didSet {
            updateInternalTimeObserver()
        }
    }

    /// The time interval at which time observers should
    /// notify the progress of the player’s current time.
    open var timeObserverInterval: TimeInterval = 10 {
        didSet {
            updateInternalTimeObserver()
        }
    }
    
    // MARK: - Interact with AVFoundation Objects

    /// The underlying AVPlayer object
    open var player: AVPlayer = AVPlayer() {
        didSet {
            updatePlayer(oldPlayer: oldValue)
        }
    }
    
    /// The underlying AVPlayerItem object currently playing
    open internal(set) var playerItem: AVPlayerItem? {
        get { player.currentItem }
        set { player.replaceCurrentItem(with: newValue) }
    }
    
    // Observers
    var playerTimeObserver: Any?
    var playerObservers: [NSKeyValueObservation] = []
    var playerItemObservers: [NSKeyValueObservation] = []
    var playerLayerObserver: NSKeyValueObservation?
    
    // Hidden vars
    var _lastBufferTime: Double = 0
    var _requestedSeekTime: CMTime?
    var _preferredPeakBitRate: Double = 0
    var _preferredMaximumResolution: CGSize = .zero
    
    var pausedReason: Richi.PausedReason = .waitKeepUp
    
    // MARK: - Creating a Media Player

    /// Initializes and returns a newly allocated media player object.
    public init() {
        commonSetup()
    }
    
    deinit {
        self.player.pause()
        self.updatePlayerItem(nil)
        
        self.removePlayerObservers()
        self.removeLifecycleObservers()
        
        self._delegate = nil
        self.timeDelegate = nil
    }
    
    func commonSetup() {
        updatePlayer()
        addPlayerObservers()
        addLifecycleObservers()
    }
    
    private func playbackStateDidChange(from oldValue: Richi.PlaybackState) {
        if case let .failed(error) = playbackState {
            _delegate?.player(self, didFailWithError: error)
        }

        _delegate?.player(self, didChangePlaybackStateFrom: oldValue, to: playbackState)
    }

    private func bufferingStateDidChange(from oldValue: Richi.BufferingState) {
        _delegate?.player(self, didChangeBufferingStateFrom: oldValue, to: bufferingState)
    }
    
}


// MARK: - Managing the Current Asset

extension MediaPlayer {

    /// Loads the given asset and prepares the player.
    /// With autoplay enabled, the asset will be played
    /// automatically as soon as the player is ready.
    ///
    /// - Parameter asset: The asset to be played
    open func load(asset: Richi.Asset) {
        self.asset = asset
    }
    
    private func _load(asset: Richi.Asset?, oldAsset: Richi.Asset?) {
        // Do nothing if the asset did not change
        guard asset != oldAsset else { return }

        // Stop the player before loading a new asset
        stop()

        playbackState = asset == nil ? .stopped : .loading
        pausedReason = .waitKeepUp
        updatePlayerItem(nil)
        
        guard let asset = asset else { return }

        updateAsset(makeAVAsset(from: asset))
    }
}


// MARK: - Controlling Playback

extension MediaPlayer {

    /// Plays the current asset from the beginning
    open func playFromBeginning() {
        player.seek(to: .zero) { _ in self.play() }
    }

    /// Continues playing the current asset if `shouldPlay` is `true`,
    /// pauses playback otherwise.
    /// - Parameter shouldPlay: Indicates if the player should play or pause
    open func play(_ shouldPlay: Bool = true) {
        guard shouldPlay else {
            pause(reason: .userInteraction)
            return
        }

        // The only reason the player pauses itself after we initiated play
        // is that it can't keep up with buffering the data.
        pausedReason = .waitKeepUp
        player.playImmediately(atRate: rate)
    }

    /// Continues playing the current asset if autoplay is enabled
    func autoPlay() {
        guard autoplay else { return }
        play()
    }

    /// Pauses playback of the current asset
    open func pause() {
        pause(reason: .userInteraction)
    }

    /// Pauses playback of the current asset
    /// while also updating the paused reason
    func pause(reason: Richi.PausedReason) {
        guard playbackState.isPausable else { return }

        pausedReason = reason
        player.pause()
    }

    /// Stops playback of the current asset.
    open func stop() {
        if playbackState == .stopped { return }

        player.pause()
        pausedReason = .stopped
        playbackState = .stopped
        _delegate?.playerDidEnd(self)
    }
}


// MARK: - Seeking through Media

extension MediaPlayer {

    /// Sets the current playback time to the specified time and executes the specified block when the seek operation completes or is interrupted.
    /// - Parameters:
    ///   - time: The time to which to seek.
    ///   - completionHandler: The block to invoke when the seek operation has either been completed or been interrupted.
    open func seek(to time: CMTime, completionHandler: ((Bool) -> Void)? = nil) {
        if let playerItem = playerItem {
            playerItem.seek(to: time, completionHandler: completionHandler)
        } else {
            _requestedSeekTime = time
        }
    }

    /// Sets the current playback time within a specified time bound and invokes the specified block when the seek operation completes or is interrupted.
    ///
    /// - Parameters:
    ///   - time: The time to which to seek.
    ///   - toleranceBefore: The tolerance allowed before time.
    ///   - toleranceAfter: The tolerance allowed after time.
    ///   - completionHandler: The block to invoke when the seek operation has either been completed or been interrupted.
    open func seek(
        to time: CMTime,
        toleranceBefore: CMTime,
        toleranceAfter: CMTime,
        completionHandler: ((Bool) -> Void)? = nil
    ) {
        guard let playerItem = playerItem else {
            _requestedSeekTime = time
            return
        }

        playerItem.seek(
            to: time,
            toleranceBefore: toleranceBefore,
            toleranceAfter: toleranceAfter,
            completionHandler: completionHandler
        )
    }
}


// MARK: - Observing Player Time

extension MediaPlayer {

    /// Requests the invocation of a block when specified times are traversed during normal playback.
    ///
    /// - Parameters:
    ///   - times: An array of CMTime values representing the times at which to invoke block.
    ///   - queue: A serial queue onto which block should be enqueued. Passing a concurrent
    ///            queue is not supported and will result in undefined behavior.
    ///            If you pass nil, the main queue is used.
    ///   - block: The block to be invoked when any of the times in times is crossed during normal playback.
    /// - Returns: An opaque object that you pass as the argument to removeTimeObserver(_:) to stop observation.
    open func addBoundaryTimeObserver(
        forTimes times: [CMTime],
        queue: DispatchQueue? = nil,
        using block: @escaping () -> Void
    ) -> Any {
        player.addBoundaryTimeObserver(
            forTimes: times.map({ NSValue(time: $0 )}),
            queue: queue,
            using: block
        )
    }

    /// Requests the periodic invocation of a given block during playback to report changing time.
    ///
    /// - Parameters:
    ///   - interval: The time interval at which the system invokes the block during normal playback,
    ///               according to progress of the player’s current time.
    ///   - queue: The dispatch queue on which the system calls the block. Passing a concurrent queue
    ///            isn’t supported and results in undefined behavior. If you pass nil, the system uses the
    ///            main queue.
    ///   - block: The block that the system periodically invokes.
    /// - Returns: An opaque object that you pass as the argument to removeTimeObserver(_:) to cancel observation.
    open func addPeriodicTimeObserver(
        forInterval interval: CMTime,
        queue: DispatchQueue? = nil,
        using block: @escaping (CMTime) -> Void
    ) -> Any {
        player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: queue,
            using: block
        )
    }

    /// Cancels a previously registered periodic or boundary time observer.
    ///
    /// - Parameter observer: An object returned by a previous call to addPeriodicTimeObserver(forInterval:queue:using:)
    ///                       or addBoundaryTimeObserver(forTimes:queue:using:).
    open func removeTimeObserver(_ observer: Any) {
        player.removeTimeObserver(observer)
    }
}


// MARK: - Player Item Loading

extension MediaPlayer {
        
    @objc func updatePlayer(oldPlayer: AVPlayer? = nil) {
        if let oldPlayer = oldPlayer {
            oldPlayer.pause()
            bufferingState = .unknown
            playbackState = .stopped
            pausedReason = .waitKeepUp
        }
        
        updatePlayerItem(player.currentItem)
    }

    func updatePlayerItem(_ playerItem: AVPlayerItem?) {
        removePlayerItemObservers()

        playerItem?.cancelPendingSeeks()
        playerItem?.asset.cancelLoading()

        guard let playerItem = playerItem else {
            self.playerItem = nil
            return
        }

        playerItem.audioTimePitchAlgorithm = .spectral
        playerItem.preferredPeakBitRate = _preferredPeakBitRate
        if #available(OSX 10.13, iOS 11.0, tvOS 11.0, *) {
            playerItem.preferredMaximumResolution = _preferredMaximumResolution
        }

        addPlayerItemObservers(to: playerItem)

        self.playerItem = playerItem

        if let time = _requestedSeekTime {
            _requestedSeekTime = nil
            seek(to: time)
        }

        player.actionAtItemEnd = actionAtEnd.action
    }

    func updateAsset(_ asset: AVAsset) {
        bufferingState = .unknown

        let keys = ["tracks", "playable", "duration"]

        asset.loadValuesAsynchronously(forKeys: keys) { [weak self] in
            guard let self = self else { return }

            for key in keys {
                var error: NSError?
                let status = asset.statusOfValue(forKey: key, error: &error)
                if status == .failed {
                    self.playbackState = .failed(.assetError(error))
                    return
                }
            }

            guard asset.isPlayable else {
                self.playbackState = .failed(.assetNotPlayable)
                return
            }

            self.updatePlayerItem({
                let playerItem = AVPlayerItem(asset: asset)
                playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = true
                return playerItem
            }())
        }
    }
    
    func makeAVAsset(from asset: Richi.Asset) -> AVAsset {
        var options: [String: Any] = [
            "AVURLAssetHTTPHeaderFieldsKey": asset.headers
        ]
        if let mimeType = asset.mimeType {
            options["AVURLAssetOutOfBandMIMETypeKey"] = mimeType
        }
        return AVURLAsset(url: asset.url, options: options)
    }
}


// MARK: - Utility

extension MediaPlayer {

    func runOnMainLoop(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }

}

extension Richi.EndAction {

    var action: AVPlayer.ActionAtItemEnd {
        switch self {
        // case .advance: return .advance
        case .freeze: return .pause
        case .loop: return .none
        case .pause: return .pause
        }
    }

}
