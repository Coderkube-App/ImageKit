//
// Copyright (c) 2026 Coderkube Technologies - ImageKit. All rights reserved.
//

import SwiftUI

public extension Image {
    /// Initializes a SwiftUI Image from a PlatformImage seamlessly.
    init(platformImage: PlatformImage) {
        #if canImport(UIKit)
        self.init(uiImage: platformImage)
        #else
        self.init(nsImage: platformImage)
        #endif
    }
}
