//
// Copyright (c) 2026 Coderkube Technologies - ImageKit. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

/// Wraps a UIImageView to support animated GIFs.
public struct AnimatedImageView: UIViewRepresentable {
    public let image: UIImage
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return imageView
    }
    
    public func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = image
    }
}
#elseif canImport(AppKit)
import AppKit

public struct AnimatedImageView: NSViewRepresentable {
    public let image: NSImage
    
    public init(image: NSImage) {
        self.image = image
    }
    
    public func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
    }
    
    public func updateNSView(_ nsView: NSImageView, context: Context) {
        nsView.image = image
    }
}
#endif
