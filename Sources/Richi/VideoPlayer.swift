//
//  VideoPlayer.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

#if canImport(AppKit)
import AppKit
/// :nodoc:
public typealias UIView = NSView
/// :nodoc:
public typealias UIImage = NSImage
#elseif canImport(UIKit)
import UIKit
#endif

import Foundation
import AVFoundation

public class VideoPlayer: MediaPlayer {
    
    // MARK: - Public Properties
    
    /// The presentation size of the current media asset.
    open var presentationSize: CGSize {
        guard let playerItem = playerItem else {
            return .zero
        }

        return playerItem.presentationSize
    }
    
    /// Indicates a preferred upper limit on the resolution of the media to be downloaded.
    @available(OSX 10.13, iOS 11.0, tvOS 11.0, *)
    open var preferredMaximumResolution: CGSize {
        get { playerItem?.preferredMaximumResolution ?? .zero }
        set {
            playerItem?.preferredMaximumResolution = newValue
            _preferredMaximumResolution = newValue
        }
    }
    
    /// The object that acts as the delegate of the video player view
    open weak var delegate: VideoPlayerDelegate? {
        get { _delegate as? VideoPlayerDelegate }
        set { _delegate = newValue }
    }
    
    var playerLayer: AVPlayerLayer? {
        didSet {
            updatePlayerLayer()
        }
    }
    
    private func updatePlayerLayer() {
        addPlayerLayerObservers()
    }
    
    deinit {
        removePlayerLayerObservers()
    }
        
}


// MARK: - Player Item Loading

extension VideoPlayer {
    
    override func updatePlayer(oldPlayer: AVPlayer? = nil) {
        super.updatePlayer(oldPlayer: oldPlayer)
        
        playerLayer?.player = player
    }
    
}


// MARK: - Snapshotting

extension VideoPlayer {
    
    /// Captures a snapshot of the current media at the specified time.
    /// If time is nil, the current time will be used.
    ///
    /// - Parameters:
    ///   - time: The time at which to capture the snapshot
    ///   - completion: The block to invoke when the snapshot completes. Provides the image if no error occured.
    open func snapshot(at time: CMTime? = nil, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        guard let asset = playerItem?.asset else {
            completion(nil, nil)
            return
        }

        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero

        let snapshotTime = time ?? currentTime

        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: snapshotTime)]) { requestedTime, image, actualTime, result, error in
            guard let image = image else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            switch result {
            case .succeeded:
                #if canImport(AppKit)
                let image = UIImage(cgImage: image, size: CGSize(width: image.width, height: image.height))
                #else
                let image = UIImage(cgImage: image)
                #endif
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            case .failed, .cancelled:
                fallthrough
            @unknown default:
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        }
    }
}


extension Richi.Gravity {

    init(videoGravity: AVLayerVideoGravity) {
        switch videoGravity {
        case .resize: self = .fill
        case .resizeAspect: self = .aspectFit
        case .resizeAspectFill: self = .aspectFill
        default: self = .fill
        }
    }
    
    #if canImport(UIKit)
    init(contentMode: UIView.ContentMode) {
        switch contentMode {
        case .scaleAspectFill: self = .aspectFill
        case .scaleAspectFit: self = .aspectFit
        case .scaleToFill: fallthrough
        default: self = .fill
        }
    }
    #endif

    var videoGravity: AVLayerVideoGravity {
        switch self {
        case .aspectFill: return .resizeAspectFill
        case .aspectFit: return .resizeAspect
        case .fill: return .resize
        }
    }
}


// MARK: - Player Layer Observers

extension VideoPlayer {
    
    func addPlayerLayerObservers() {
        playerLayerObserver = playerLayer?.observe(\.isReadyForDisplay, options: [.new, .old]) { [weak self] (object, change) in
            guard let self = self else { return }
            
            self.runOnMainLoop {
                self.delegate?.playerReadyForDisplay(self)
            }
        }
    }

    func removePlayerLayerObservers() {
        playerLayerObserver?.invalidate()
        playerLayerObserver = nil
    }
}
