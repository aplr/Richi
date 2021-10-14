//
//  AudioViewController+ViewModel.swift
//  App
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

import Foundation
import Richi
import Apollo
import Combine

extension AudioView {
 
    class ViewModel: ObservableObject {
        
        @Published var podcast: GetPodcastQuery.Data.Podcast? {
            didSet {
                currentEpisode = podcast?.episodes?.data.randomElement()
            }
        }
        
        @Published var currentEpisode: GetPodcastQuery.Data.Podcast.Episode.Datum?
        
        private var cancellables = Set<AnyCancellable>()
        
        init() {
            Client.shared.getPodcast(id: "394775318")
                .map({ $0.podcast })
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .assign(to: \.podcast, on: self)
                .store(in: &cancellables)
        }
        
    }
    
}

extension AudioView.ViewModel: MediaPlayerDelegate {
    
    
    
}
