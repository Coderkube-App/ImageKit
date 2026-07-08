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

/// A compact decoder for BlurHash strings.
public class BlurHashDecoder {
    
    // Very simplified placeholder for BlurHash.
    // A complete implementation of BlurHash involves decoding base83 and cosine transforms.
    // To keep the package lightweight, this is a simplified stub that generates a blurred color
    // placeholder based on the hash's length, or you could integrate a full BlurHash library.
    
    public static func decode(blurHash: String, size: CGSize = CGSize(width: 32, height: 32)) -> PlatformImage? {
        guard blurHash.count >= 6 else { return nil }
        
        // As a fallback/stub for a full 200-line BlurHash decoder, we generate a solid color.
        // In a production environment, you would use the full cosine transform algorithm.
        #if canImport(UIKit)
        let format = UIGraphicsImageRendererFormat()
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            // Generate a color based on the hash (pseudo-random for stub)
            let color = UIColor(
                red: CGFloat(blurHash.utf8.first ?? 0) / 255.0,
                green: CGFloat(blurHash.utf8.dropFirst().first ?? 0) / 255.0,
                blue: CGFloat(blurHash.utf8.dropFirst(2).first ?? 0) / 255.0,
                alpha: 1.0
            )
            color.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
        #else
        let newImage = NSImage(size: size)
        newImage.lockFocus()
        NSColor.gray.setFill()
        NSRect(origin: .zero, size: size).fill()
        newImage.unlockFocus()
        return newImage
        #endif
    }
}
