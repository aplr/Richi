//
//  AudioViewController.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

import UIKit
import SwiftUI
import Richi

class AudioViewController: UIHostingController<AudioView> {
    
    init() {
        super.init(rootView: AudioView())
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

struct AudioView: View {
    
    @ObservedObject private var audioPlayer = SUIAudioPlayer()
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        Group {
            if let podcast = viewModel.podcast, let episode = viewModel.currentEpisode {
                PodcastView(podcast: podcast, episode: episode, isPlaying: audioPlayer.isPlaying)
            } else {
                EmptyView()
            }
        }.onReceive(viewModel.$currentEpisode) {
            play(episode: $0)
        }
    }
    
    private func play(episode: GetPodcastQuery.Data.Podcast.Episode.Datum?) {
        guard let episode = episode, let urlString = episode.audioUrl, let url = URL(string: urlString) else {
            return
        }

        audioPlayer.asset = Richi.Asset(url: url)
    }
    
}

struct PodcastView: View {
    
    let podcast: GetPodcastQuery.Data.Podcast
    
    let episode: GetPodcastQuery.Data.Podcast.Episode.Datum
    
    let isPlaying: Binding<Bool>
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 16) {
                if let imageUrl = podcast.imageUrl.flatMap({ URL(string: $0) }) {
                    AsyncImage(url: imageUrl) {
                        switch $0 {
                        case let .success(image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .cornerRadius(16, antialiased: true)
                                .clipped(antialiased: true)
                        case let .failure(error):
                            Text(error.localizedDescription)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(episode.title).font(.largeTitle)
                    
                    Text(podcast.title).font(.title2)
                    if let authorName = podcast.author?.name {
                        Text(authorName)
                    }
                }.frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer()
                HStack {
                    Button(action: {
                        self.isPlaying.wrappedValue.toggle()
                    }) {
                        Image(systemName: isPlaying.wrappedValue ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 72))
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                }
            }
        }.padding()
    }
    
}

class SUIAudioPlayer: ObservableObject {
    
    private lazy var audioPlayer: AudioPlayer = {
        let player = AudioPlayer()
        player.autoplay = true
        player.actionAtEnd = .loop
        player.delegate = self
        return player
    }()
    
    var isPlaying: Binding<Bool> {
        Binding<Bool>(
            get: { self.audioPlayer.isPlaying },
            set: { self.audioPlayer.isPlaying = $0 }
        )
    }
    
    var isMuted: Binding<Bool> {
        Binding<Bool>(
            get: { self.audioPlayer.isMuted },
            set: { self.audioPlayer.isMuted = $0 }
        )
    }
    
    var asset: Richi.Asset? {
        get { audioPlayer.asset }
        set { audioPlayer.asset = newValue }
    }
    
}

extension SUIAudioPlayer: MediaPlayerDelegate {
    
    func player(_ player: MediaPlayer, didChangePlaybackStateFrom oldState: Richi.PlaybackState, to newState: Richi.PlaybackState) {
        objectWillChange.send()
    }
    
}
