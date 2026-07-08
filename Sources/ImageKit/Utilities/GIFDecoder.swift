//
// Copyright (c) 2026 Coderkube Technologies - ImageKit. All rights reserved.
//

import Foundation
import ImageIO

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Decodes animated GIF data into an animated PlatformImage.
public class GIFDecoder {
    
    /// Decodes a GIF data blob into an animated image if supported.
    public static func decode(data: Data) -> PlatformImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        
        let count = CGImageSourceGetCount(source)
        guard count > 1 else {
            return PlatformImage(data: data)
        }
        
        #if canImport(UIKit)
        var images = [UIImage]()
        var duration: TimeInterval = 0
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
                
                let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any]
                let gifInfo = properties?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
                
                let delayTime = gifInfo?[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double ??
                                gifInfo?[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
                
                duration += delayTime
            }
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
        #else
        return NSImage(data: data)
        #endif
    }
}
