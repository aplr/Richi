//
//  VideoPlayerView.swift
//  Core
//
//  Created by Andreas Pfurtscheller on 07.04.21.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import AVFoundation

/// An object that displays a single video asset or a playlist of video assets in your interface.
public class VideoPlayerView: UIView {

    // MARK: - Public Properties

    /// A value that specifies how the video is displayed within the view's bounds.
    open var gravity: Richi.Gravity {
        get { Richi.Gravity(videoGravity: playerLayer.videoGravity) }
        set { playerLayer.videoGravity = newValue.videoGravity }
    }

    /// Determines if the video should autoplay
    open var autoplay: Bool {
        get { videoPlayer.autoplay }
        set { videoPlayer.autoplay = newValue }
    }

    /// The audio playback volume for the player.
    open var volume: Float {
        get { videoPlayer.volume }
        set { videoPlayer.volume = newValue }
    }

    /// A Boolean value that indicates whether the audio output of the player is muted.
    open var isMuted: Bool {
        get { videoPlayer.isMuted }
        set { videoPlayer.isMuted = newValue }
    }

    /// A Boolean value that indicates whether video playback prevents display and device sleep.
    @available(OSX 10.14, iOS 12.0, tvOS 12.0, *)
    open var preventsDisplaySleepDuringPlayback: Bool {
        get { player.preventsDisplaySleepDuringVideoPlayback }
        set { player.preventsDisplaySleepDuringVideoPlayback = newValue }
    }

    /// A boolean value that indicates whether video playback is playing
    open var isPlaying: Bool {
        get { videoPlayer.isPlaying }
        set { videoPlayer.isPlaying = newValue }
    }

    /// The current playback rate
    open var rate: Float {
        get { videoPlayer.rate }
        set { videoPlayer.rate = newValue }
    }

    /// The action to perform when the current player item has finished playing.
    open var actionAtEnd: Richi.EndAction {
        get { videoPlayer.actionAtEnd }
        set { videoPlayer.actionAtEnd = newValue }
    }

    // MARK: - Control Lifecycle Behavior

    /// Controls if playback is paused when the application is no longer active.
    /// This is because of temporary interruptions such as incoming phone calls,
    /// messages or when the app is backgrounded by the user.
    open var pauseWhenResigningActive: Bool {
        get { videoPlayer.pauseWhenResigningActive }
        set { videoPlayer.pauseWhenResigningActive = newValue }
    }

    /// Controls if playback is paused when the application enters the background.
    /// This is triggered by the user sending the app to the background or locking the device.
    open var pauseWhenEnteringBackground: Bool {
        get { videoPlayer.pauseWhenEnteringBackground }
        set { videoPlayer.pauseWhenEnteringBackground = newValue }
    }

    /// Controls if playback is resumed when the application has become active.
    /// Playback will be resumed only if the player was paused because of some temporary interruption.
    open var resumeWhenBecomingActive: Bool {
        get { videoPlayer.resumeWhenBecomingActive }
        set { videoPlayer.resumeWhenBecomingActive = newValue }
    }

    /// Controls if playback is resumed when the application is about to enter the foreground
    open var resumeWhenEnteringForeground: Bool {
        get { videoPlayer.resumeWhenEnteringForeground }
        set { videoPlayer.resumeWhenEnteringForeground = newValue }
    }

    /// The current asset
    open var asset: Richi.Asset? {
        get { videoPlayer.asset }
        set { videoPlayer.asset = newValue }
    }

    /// Current playback state of the Player
    open var playbackState: Richi.PlaybackState {
        videoPlayer.playbackState
    }

    /// Current buffering state of the Player
    open var bufferingState: Richi.BufferingState {
        videoPlayer.bufferingState
    }

    /// The size of the current video asset.
    open var videoSize: CGSize {
        videoPlayer.presentationSize
    }

    /// Maximum duration of playback.
    open var duration: TimeInterval {
        videoPlayer.duration
    }

    /// Media playback's current time.
    open var currentTime: CMTime {
        videoPlayer.currentTime
    }

    /// Indicates the desired limit of network bandwidth consumption for this item.
    open var preferredPeakBitRate: Double {
        get { videoPlayer.preferredPeakBitRate }
        set { videoPlayer.preferredPeakBitRate = newValue }
    }

    /// Indicates a preferred upper limit on the resolution of the video to be downloaded.
    @available(OSX 10.13, iOS 11.0, tvOS 11.0, *)
    open var preferredMaximumResolution: CGSize {
        get { videoPlayer.preferredMaximumResolution }
        set { videoPlayer.preferredMaximumResolution = newValue }
    }

    /// Media playback's current time interval in seconds.
    open var currentDuration: TimeInterval {
        videoPlayer.currentDuration
    }

    /// The object that acts as the delegate of the video player view
    open weak var delegate: VideoPlayerDelegate? {
        get { videoPlayer.delegate }
        set { videoPlayer.delegate = newValue }
    }

    /// The object that acts as the time delegate of the video player view
    open weak var timeDelegate: MediaPlayerTimeDelegate? {
        get { videoPlayer.timeDelegate }
        set { videoPlayer.timeDelegate = newValue }
    }

    /// The time interval at which time observers should
    /// notify the progress of the player’s current time.
    open var timeObserverInterval: TimeInterval {
        get { videoPlayer.timeObserverInterval }
        set { videoPlayer.timeObserverInterval = newValue }
    }

    // MARK: - Interact with AVFoundation Objects

    /// The underlying AVPlayer object
    open var player: AVPlayer {
        get { videoPlayer.player }
        set { videoPlayer.player = newValue }
    }
    
    open internal(set) lazy var videoPlayer: VideoPlayer = {
        VideoPlayer()
    }()

    /// The underlying AVPlayerItem object currently playing
    open var playerItem: AVPlayerItem? {
        videoPlayer.playerItem
    }

    #if canImport(UIKit)
    /// :nodoc:
    public override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    #endif

    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

    #if canImport(UIKit)
    public override var contentMode: UIView.ContentMode {
        didSet {
            gravity = Richi.Gravity(contentMode: contentMode)
        }
    }
    #endif

    // MARK: - Creating a Video Player View

    /// Initializes and returns a newly allocated player view object with a zero rect frame.
    public init() {
        super.init(frame: .zero)
        commonSetup()
    }

    /// Initializes and returns a newly allocated player view object from the specified coder.
    ///
    /// - Parameter coder: The coder object
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }

    private func commonSetup() {
        #if canImport(AppKit)
        wantsLayer = true
        layer = AVPlayerLayer()
        #endif

        playerLayer.player = player
    }
}


// MARK: - Managing the Current Asset

extension VideoPlayerView {

    /// Loads the given asset and prepares the player.
    /// With autoplay enabled, the asset will be played
    /// automatically as soon as the player is ready.
    ///
    /// - Parameter asset: The asset to be played
    open func load(asset: Richi.Asset) {
        videoPlayer.load(asset: asset)
    }
}


// MARK: - Controlling Playback

extension VideoPlayerView {

    /// Plays the current asset from the beginning
    open func playFromBeginning() {
        videoPlayer.playFromBeginning()
    }

    /// Continues playing the current asset if `shouldPlay` is `true`,
    /// pauses playback otherwise.
    /// - Parameter shouldPlay: Indicates if the player should play or pause
    open func play(_ shouldPlay: Bool = true) {
        videoPlayer.play(shouldPlay)
    }

    /// Pauses playback of the current asset
    open func pause() {
        videoPlayer.pause()
    }

    /// Stops playback of the current asset.
    open func stop() {
        videoPlayer.stop()
    }
}


// MARK: - Seeking through Media

extension VideoPlayerView {

    /// Sets the current playback time to the specified time and executes the specified block when the seek operation completes or is interrupted.
    /// - Parameters:
    ///   - time: The time to which to seek.
    ///   - completionHandler: The block to invoke when the seek operation has either been completed or been interrupted.
    open func seek(to time: CMTime, completionHandler: ((Bool) -> Void)? = nil) {
        videoPlayer.seek(to: time, completionHandler: completionHandler)
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
        videoPlayer.seek(
            to: time,
            toleranceBefore: toleranceBefore,
            toleranceAfter: toleranceAfter,
            completionHandler: completionHandler
        )
    }

    /// Captures a snapshot of the current media at the specified time.
    /// If time is nil, the current time will be used.
    ///
    /// - Parameters:
    ///   - time: The time at which to capture the snapshot
    ///   - completion: The block to invoke when the snapshot completes. Provides the image if no error occured.
    open func snapshot(at time: CMTime? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        videoPlayer.snapshot(at: time, completion: completion)
    }
}


// MARK: - Observing Player Time

extension VideoPlayerView {

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
        videoPlayer.addBoundaryTimeObserver(forTimes: times, queue: queue, using: block)
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
        videoPlayer.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: block)
    }

    /// Cancels a previously registered periodic or boundary time observer.
    ///
    /// - Parameter observer: An object returned by a previous call to addPeriodicTimeObserver(forInterval:queue:using:)
    ///                       or addBoundaryTimeObserver(forTimes:queue:using:).
    open func removeTimeObserver(_ observer: Any) {
        videoPlayer.removeTimeObserver(observer)
    }
}
