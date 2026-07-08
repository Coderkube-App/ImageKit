//
// Copyright (c) 2026 Coderkube Technologies - ImageKit. All rights reserved.
//

import SwiftUI

public struct CachedImage<Placeholder: View>: View {
    let url: URL?
    let blurHash: String?
    let placeholder: () -> Placeholder
    
    @State private var image: PlatformImage?
    @State private var isLoading = false
    @State private var isError = false
    
    public init(
        url: URL?,
        blurHash: String? = nil,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.blurHash = blurHash
        self.placeholder = placeholder
    }
    
    public var body: some View {
        Group {
            if let image = image {
                // If it's a GIF with multiple frames, use AnimatedImageView
                #if canImport(UIKit)
                if image.images != nil {
                    AnimatedImageView(image: image)
                } else {
                    Image(uiImage: image)
                        .resizable()
                }
                #else
                AnimatedImageView(image: image)
                #endif
            } else if let hash = blurHash, let blurHashImage = BlurHashDecoder.decode(blurHash: hash) {
                #if canImport(UIKit)
                Image(uiImage: blurHashImage)
                    .resizable()
                #else
                Image(nsImage: blurHashImage)
                    .resizable()
                #endif
            } else if isLoading {
                placeholder()
            } else if isError {
                placeholder()
            } else {
                placeholder()
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url else {
            isError = true
            return
        }
        
        let cacheKey = url.absoluteString
        
        // Check cache first
        if let cached = ImageCacheManager.shared.get(forKey: cacheKey) {
            self.image = GIFDecoder.decode(data: cached.data ?? Data()) ?? cached.image
            return
        }
        
        isLoading = true
        
        do {
            let (data, _) = try await ImageDownloader.shared.download(from: url)
            
            if let decodedImage = GIFDecoder.decode(data: data) {
                ImageCacheManager.shared.set(decodedImage, data: data, forKey: cacheKey)
                self.image = decodedImage
            } else {
                isError = true
            }
        } catch {
            isError = true
        }
        
        isLoading = false
    }
}

public extension CachedImage where Placeholder == ProgressView<EmptyView, EmptyView> {
    init(url: URL?, blurHash: String? = nil) {
        self.init(url: url, blurHash: blurHash) {
            ProgressView()
        }
    }
}
