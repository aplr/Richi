//
//  DataCaching.swift
//  
//
//  Created by Andreas Pfurtscheller on 11.10.21.
//

import Foundation

/// Data cache.
///
/// - warning: The implementation must be thread safe.
public protocol DataCaching {
    /// Retrieves data from cache for the given key.
    func data(for key: String) -> Data?

    /// Returns `true` if the cache contains data for the given key.
    func has(key: String) -> Bool

    /// Stores data for the given key.
    /// - note: The implementation must return immediately and store data asynchronously.
    func put(_ data: Data, for key: String)

    /// Removes data for the given key.
    /// - note: The implementation must return immediately and remote data asynchronously
    func remove(for key: String)

    /// Removes all items.
    func removeAll()
}
