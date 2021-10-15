//
//  MediaPlayer+Combine.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 07.04.21.
//

#if canImport(Combine)
import Combine
import Foundation
import AVFoundation

// MARK: - Time Publishers

extension MediaPlayer {

    /// Creates a publisher that emits an event when specified times are traversed during normal playback.
    ///
    /// - Parameter times: An array of CMTime values representing the times at which to emit events.
    /// - Returns: A publisher that emits events when traversing specific times.
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, *)
    open func boundaryTimePublisher(forTimes times: [CMTime]) -> AnyPublisher<Void, Never> {
        AnyPublisher { [weak self] subscriber in
            guard let self = self else {
                subscriber.send(completion: .finished)
                return AnyCancellable {}
            }

            // TODO: Specify Queue
            let observer = self.addBoundaryTimeObserver(forTimes: times, queue: nil) {
                subscriber.send(())
            }

            return AnyCancellable {
                self.removeTimeObserver(observer)
            }
        }
    }


    /// Creates a publisher that periodically emits the changing time of the current playback.
    ///
    /// - Parameter interval: The time interval at which the system invokes the block
    ///                       during normal playback, according to progress of the player’s current time.
    /// - Returns: A publisher that emits the changing time.
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, *)
    open func periodicTimePublisher(forInterval interval: CMTime) -> AnyPublisher<CMTime, Never> {
        AnyPublisher { [weak self] subscriber in
            guard let self = self else {
                subscriber.send(completion: .finished)
                return AnyCancellable {}
            }

            // TODO: Specify Queue
            let observer = self.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
                subscriber.send(time)
            }

            return AnyCancellable {
                self.removeTimeObserver(observer)
            }
        }
    }
}
#endif
