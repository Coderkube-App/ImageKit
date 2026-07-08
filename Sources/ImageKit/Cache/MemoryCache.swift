//
// Copyright (c) 2026 Coderkube Technologies - ImageKit. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

/// In-memory cache for images using NSCache.
public final class MemoryCache: @unchecked Sendable {
    public static let shared = MemoryCache()
    
    private let cache = NSCache<NSString, PlatformImage>()
    
    private init() {
        // Default limits
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB approx
    }
    
    public func set(_ image: PlatformImage, forKey key: String) {
        // Calculate rough cost (number of pixels)
        let cost: Int
        #if canImport(UIKit)
        cost = Int(image.size.width * image.size.height * image.scale)
        #else
        cost = Int(image.size.width * image.size.height)
        #endif
        
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
    
    public func get(forKey key: String) -> PlatformImage? {
        return cache.object(forKey: key as NSString)
    }
    
    public func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    public func clear() {
        cache.removeAllObjects()
    }
}
