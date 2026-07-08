//
// Copyright (c) 2026 Coderkube Technologies - ImageKit. All rights reserved.
//

import Foundation
import CryptoKit

/// Persistent cache for images on the file system.
public final class DiskCache: @unchecked Sendable {
    public static let shared = DiskCache()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let ioQueue = DispatchQueue(label: "com.imagekit.diskcache", attributes: .concurrent)
    
    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageKitCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    public func set(_ data: Data, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(filename(for: key))
        ioQueue.async(flags: .barrier) {
            try? data.write(to: fileURL)
        }
    }
    
    public func get(forKey key: String) -> Data? {
        let fileURL = cacheDirectory.appendingPathComponent(filename(for: key))
        var data: Data?
        ioQueue.sync {
            data = try? Data(contentsOf: fileURL)
        }
        return data
    }
    
    public func remove(forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(filename(for: key))
        ioQueue.async(flags: .barrier) {
            try? self.fileManager.removeItem(at: fileURL)
        }
    }
    
    public func clear() {
        ioQueue.async(flags: .barrier) {
            try? self.fileManager.removeItem(at: self.cacheDirectory)
            try? self.fileManager.createDirectory(at: self.cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    private func filename(for key: String) -> String {
        let hash = Insecure.MD5.hash(data: Data(key.utf8))
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
