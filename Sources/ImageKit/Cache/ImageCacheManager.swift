//
// Copyright (c) 2026 Coderkube Technologies - ImageKit. All rights reserved.
//

import Foundation

/// Facade to manage both Memory and Disk caches for ImageKit.
public final class ImageCacheManager: @unchecked Sendable {
    public static let shared = ImageCacheManager()
    
    private let memoryCache = MemoryCache.shared
    private let diskCache = DiskCache.shared
    
    private init() {}
    
    /// Retrieves an image from cache. Checks memory first, then disk.
    public func get(forKey key: String) -> (image: PlatformImage, data: Data?)? {
        if let memImage = memoryCache.get(forKey: key) {
            return (memImage, nil)
        }
        
        if let diskData = diskCache.get(forKey: key), let image = PlatformImage(data: diskData) {
            // Restore to memory cache for faster subsequent access
            memoryCache.set(image, forKey: key)
            return (image, diskData)
        }
        
        return nil
    }
    
    /// Saves an image and its raw data to cache (memory + disk).
    public func set(_ image: PlatformImage, data: Data, forKey key: String) {
        memoryCache.set(image, forKey: key)
        diskCache.set(data, forKey: key)
    }
    
    /// Removes an image from all caches.
    public func remove(forKey key: String) {
        memoryCache.remove(forKey: key)
        diskCache.remove(forKey: key)
    }
    
    /// Clears all caches.
    public func clear() {
        memoryCache.clear()
        diskCache.clear()
    }
}
