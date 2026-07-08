//
// Copyright (c) 2026 Coderkube Technologies - ImageKit. All rights reserved.
//

import Foundation
import CoreGraphics

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Utility for compressing, resizing, and transforming images.
public class ImageProcessor {
    
    /// Compresses a PlatformImage to a target byte size using JPEG compression.
    /// Note: Returns compressed Data, not an Image.
    public static func compress(_ image: PlatformImage, targetBytes: Int) -> Data? {
        #if canImport(UIKit)
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.1
        var data = image.jpegData(compressionQuality: compression)
        
        while let currentData = data, currentData.count > targetBytes, compression > 0 {
            compression -= step
            data = image.jpegData(compressionQuality: compression)
        }
        return data
        #else
        // Basic AppKit fallback
        guard let tiff = image.tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiff) else { return nil }
        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.7])
        #endif
    }
    
    /// Resizes an image to a target size.
    public static func resize(_ image: PlatformImage, to size: CGSize) -> PlatformImage? {
        #if canImport(UIKit)
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        #else
        let newImage = NSImage(size: size)
        newImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: size),
                   from: NSRect(origin: .zero, size: image.size),
                   operation: .sourceOver,
                   fraction: 1.0)
        newImage.unlockFocus()
        return newImage
        #endif
    }
}
