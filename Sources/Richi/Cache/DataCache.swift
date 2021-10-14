//
//  DataCache.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 11.10.21.
//

import Foundation
import PINCache

/// A LRU disk cache that stores data using the underlying `PINCache`.
///
/// The cache uses the LRU cleanup policy (last recently used items are removed first).
/// The elements stored in the cache are automatically discarded if *cost* limit is reached.
/// Cache sweeps are performed periodically on a background queue.
///
/// Write and remove operations are performed asynchronously.
///
/// Thread-safe.
///
/// - Warning: Multiple instances with the same `name` are **not** allowed
///            and can **not** safely access the same data on disk.
public final class DataCache: DataCaching {
    
    public static let shared = DataCache(name: "com.github.aplr.Richi.DataCache")
    
    /// The name of this cache instance.
    public let name: String
    
    /// Size limit in bytes, `128 Mb` by default.
    ///
    /// Changes to `sizeLimit` will take effect when the next LRU sweep runs.
    public var sizeLimit: Int = 1024 * 1024 * 128
    
    /// Sweep files until cache size is lower than `sizeLimit * trimRatio`.
    /// `0.7` by default.
    var trimRatio = 0.7
    
    /// The number of seconds between each LRU sweep. `30` by default.
    ///
    /// Sweeps are performed on a background queue and can run parallel to reads.
    public var sweepInterval: TimeInterval = 30
    
    /// The number of seconds until the first LRU sweep is performed. `10` by default.
    private var initialSweepDelay: TimeInterval = 10
    
    /// The underlying data cache
    private lazy var cache: PINCache = {
        PINCache(name: name)
    }()
    
    private let sweepQueue = DispatchQueue(
        label: "com.github.aplr.Richi.DataCache.SweepQueue",
        qos: .utility
    )
    
    /// Creates a cache instance with a given `name`.
    /// - Note Multiple instances with the same `name` are **not** allowed and can **not** safely access 
    /// - Parameter name: Cache name
    init(name: String) {
        self.name = name
        sweepQueue.asyncAfter(deadline: .now() + initialSweepDelay) { [weak self] in
            self?.performAndScheduleSweep()
        }
    }
    
    // MARK: Public interface
    
    /// Retrieves data for the given key.
    ///
    /// - Parameter key: Cache key
    /// - Returns: Data if present for the given key, `nil` otherwise
    public func data(for key: String) -> Data? {
        guard let cacheKey = cacheKey(for: key) else {
            return nil
        }
        
        return cache.object(forKey: cacheKey) as? Data
    }
    
    /// Returns `true` if the cache contains the data for the given key.
    ///
    /// - Parameter key: Cache key
    /// - Returns: `true` if data exists, `false` otherwise.
    public func has(key: String) -> Bool {
        guard let cacheKey = cacheKey(for: key) else {
            return false
        }
        
        return cache.containsObject(forKey: cacheKey)
    }
    
    /// Stores data for the given key. The method returns immediately,
    /// the data is stored asynchronously.
    ///
    /// - Parameters:
    ///   - data: The data to store
    ///   - key: Cache key
    public func put(_ data: Data, for key: String) {
        guard let cacheKey = cacheKey(for: key) else {
            return
        }
        
        return cache.setObjectAsync(data, forKey: cacheKey, completion: nil)
    }
    
    /// Removes data for the given key. The method returns immediately,
    /// the data is removed asynchronously.
    /// 
    /// - Parameter key: Cache key
    public func remove(for key: String) {
        guard let cacheKey = cacheKey(for: key) else {
            return
        }
        
        return cache.removeObject(forKeyAsync: cacheKey, completion: nil)
    }
    
    /// Removes all items. The method returns immediately, the data
    /// is removed asynchronously
    public func removeAll() {
        cache.removeAllObjectsAsync(nil)
    }
    
    // MARK: Cache key
    
    /// Generates a stable cache key given a valid, non-empty string
    ///
    /// - Parameter key: Input cache key
    /// - Returns: SHA256 hashed cache key
    private func cacheKey(for key: String) -> String? {
        key.sha256
    }
    
    // MARK: Sweep
    
    private func performAndScheduleSweep() {
        performSweep()
        sweepQueue.asyncAfter(deadline: .now() + sweepInterval) { [weak self] in
            self?.performAndScheduleSweep()
        }
    }
    
    /// Synchronously performs a cache sweep and removes
    /// the least recently items which no longer fit in cache.
    public func sweep() {
        sweepQueue.sync(execute: performSweep)
    }
    
    /// Discards the least recently used items first.
    private func performSweep() {
        cache.diskCache.trimToSize(byDate: UInt(Double(sizeLimit) * trimRatio))
    }
    
}
