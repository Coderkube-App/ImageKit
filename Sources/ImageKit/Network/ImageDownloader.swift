//
// Copyright (c) 2026 Coderkube Technologies - ImageKit. All rights reserved.
//

import Foundation

/// Handles asynchronous image downloading, retries, and returning data/image.
public final class ImageDownloader: @unchecked Sendable {
    public static let shared = ImageDownloader()
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: config)
    }
    
    public enum DownloadError: Error {
        case badResponse
        case invalidData
        case retriesExhausted
    }
    
    /// Downloads an image from a URL, with built-in retries.
    public func download(from url: URL, retries: Int = 3) async throws -> (data: Data, image: PlatformImage) {
        var currentAttempt = 0
        
        while currentAttempt <= retries {
            do {
                let (data, response) = try await session.data(from: url)
                guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
                    throw DownloadError.badResponse
                }
                
                guard let image = PlatformImage(data: data) else {
                    throw DownloadError.invalidData
                }
                
                return (data, image)
                
            } catch {
                currentAttempt += 1
                if currentAttempt > retries {
                    throw DownloadError.retriesExhausted
                }
                // Optional backoff strategy can be added here
                try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(currentAttempt)) * 1_000_000_000))
            }
        }
        
        throw DownloadError.retriesExhausted
    }
}
