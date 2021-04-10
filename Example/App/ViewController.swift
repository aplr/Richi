//
//  ViewController.swift
//  App
//
//  Created by Andreas Pfurtscheller on 10.04.21.
//

import UIKit
import Richi
import Combine

class ViewController: UIViewController {
    
    private lazy var videoPlayer: VideoPlayer = {
        let view = VideoPlayer()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionAtEnd = .loop
        view.delegate = self
        view.gravity = .aspectFit
        view.autoplay = true
        view.resumeWhenBecomingActive = true
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(videoPlayer)
        view.addConstraints([
            videoPlayer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoPlayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoPlayer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoPlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        
        videoPlayer.load(asset: .init(url: videoURL))
    }
}

extension ViewController: VideoPlayerDelegate {
    
    func playerReady(_ player: VideoPlayer) {
        print("Player Ready")
        videoPlayer.play()
    }
    
    func player(_ player: VideoPlayer, didChangePlaybackStateFrom oldState: Richi.PlaybackState, to newState: Richi.PlaybackState) {
        
    }
    
    func player(_ player: VideoPlayer, didChangeBufferingStateFrom oldState: Richi.BufferingState, to newState: Richi.BufferingState) {
        
    }
    
    func player(_ player: VideoPlayer, didChangeBufferTime bufferTime: Double) {
        
    }
    
    func player(_ player: VideoPlayer, didFailWithError error: Richi.Error) {
        print("Player Failed")
    }
    
    func player(_ player: VideoPlayer, didLoadAsset asset: Richi.Asset) {
        print("Player Loaded Asset")
    }
    
    func playerWillStartFromBeginning(_ player: VideoPlayer) {
        print("Player Will Start From Beginning")
    }
    
    func playerDidEnd(_ player: VideoPlayer) {
        print("Player Did End")
    }
    
    func playerWillLoop(_ player: VideoPlayer) {
        print("Player Will Loop")
    }
    
    func playerDidLoop(_ player: VideoPlayer) {
        print("Player Did Loop")
    }
    
}
