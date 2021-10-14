//
//  ViewController.swift
//  App
//
//  Created by Andreas Pfurtscheller on 10.04.21.
//

import UIKit
import Richi
import Combine

class VideoViewController: UIViewController {
    
    private lazy var videoPlayer: VideoPlayerView = {
        let view = VideoPlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionAtEnd = .loop
        view.delegate = self
        view.gravity = .aspectFit
        view.autoplay = true
        view.resumeWhenBecomingActive = true
        return view
    }()
    
    private lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPause))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        return gestureRecognizer
    }()
    
    private lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoom))
        gestureRecognizer.numberOfTapsRequired = 2
        return gestureRecognizer
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        UIDevice.current.orientation.isLandscape
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(videoPlayer)
        view.addConstraints([
            videoPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayer.topAnchor.constraint(equalTo: view.topAnchor),
            videoPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        view.addGestureRecognizer(singleTapGestureRecognizer)
        
        let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        
        videoPlayer.load(asset: .init(url: videoURL))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceDidRotate),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func playPause() {
        videoPlayer.isPlaying.toggle()
    }
    
    @objc private func zoom() {
        videoPlayer.gravity = videoPlayer.gravity == .aspectFill ? .aspectFit : .aspectFill
    }
    
    @objc private func deviceDidRotate() {
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
}

extension VideoViewController: VideoPlayerDelegate {
    
    func playerReady(_ player: MediaPlayer) {
        print("Player Ready")
    }
    
    func playerReadyForDisplay(_ player: MediaPlayer) {
        print("Player Ready For Display")
    }
    
    func player(
        _ player: MediaPlayer,
        didChangePlaybackStateFrom oldState: Richi.PlaybackState,
        to newState: Richi.PlaybackState
    ) {
        
    }
    
    func player(
        _ player: MediaPlayer,
        didChangeBufferingStateFrom oldState: Richi.BufferingState,
        to newState: Richi.BufferingState
    ) {
        
    }
    
    func player(_ player: MediaPlayer, didChangeBufferTime bufferTime: Double) {
        
    }
    
    func player(_ player: MediaPlayer, didFailWithError error: Richi.Error) {
        print("Player Failed")
    }
    
    func player(_ player: MediaPlayer, didLoadAsset asset: Richi.Asset) {
        print("Player Loaded Asset")
    }
    
    func player(_ player: MediaPlayer, didChangePresentationSize size: CGSize) {
        print("Payer Did Change Presentation Size")
    }
    
    func playerDidEnd(_ player: MediaPlayer) {
        print("Player Did End")
    }
    
    func playerDidPlayToEnd(_ player: MediaPlayer) {
        print("Player Did Play To End")
    }
    
    func playerWillLoop(_ player: MediaPlayer) {
        print("Player Will Loop")
    }
    
    func playerDidLoop(_ player: MediaPlayer) {
        print("Player Did Loop")
    }
    
}
