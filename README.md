# ImageKit

`ImageKit` is a complete, high-performance image loading and caching package for SwiftUI. It provides asynchronous image loading, memory and disk caching, BlurHash placeholders, progressive loading, animated GIF support, and image compression utilities.

## Requirements

- iOS 15.0+
- macOS 12.0+
- Swift 6.0+

## Features

- **Async image loading:** Non-blocking downloads via URLSession.
- **Memory cache:** Fast in-memory retrieval using `NSCache`.
- **Disk cache:** Persistent file-system storage using `FileManager`.
- **Placeholder:** Native SwiftUI views as placeholders.
- **Retry mechanism:** Built-in configurable retries for failed network requests.
- **Progressive loading:** Caches image data smoothly.
- **BlurHash placeholder:** Decodes BlurHash strings into blurred images before the main image loads.
- **GIF support:** Automatic decoding and rendering of animated GIFs using `CGImageSource`.
- **SVG support:** Standard SVG loading via UIImage data rendering (Note: Full network SVG path parsing requires additional WKWebView wrappers based on use-case).
- **Image compression:** Utilities to resize and compress images (JPEG quality scaling).
- **Offline support:** Fetches from disk cache when offline.
- **Image transformations:** Resize images dynamically.

## Package Structure

```text
ImageKit/
 ├── Sources/ImageKit/
 │   ├── Cache/        (MemoryCache, DiskCache, ImageCacheManager)
 │   ├── Network/      (ImageDownloader)
 │   ├── Views/        (CachedImage, AnimatedImageView)
 │   ├── Placeholder/  (BlurHashDecoder)
 │   ├── Utilities/    (ImageProcessor, GIFDecoder)
 │   └── Extensions/   (Image+Extensions)
 ├── Tests/ImageKitTests/
 └── Package.swift
```

## Usage

### Basic Usage

You can use `CachedImage` seamlessly in SwiftUI.

```swift
import ImageKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        CachedImage(url: URL(string: "https://example.com/image.jpg"))
            .frame(width: 200, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
```

### Custom Placeholder

Provide any SwiftUI view as a placeholder while the image loads.

```swift
CachedImage(url: URL(string: "https://example.com/image.jpg")) {
    ProgressView("Loading...")
        .progressViewStyle(CircularProgressViewStyle())
}
```

### BlurHash Placeholder

If your backend provides a BlurHash string, you can pass it to show a beautifully blurred preview before the main image loads.

```swift
CachedImage(
    url: URL(string: "https://example.com/image.jpg"),
    blurHash: "LKO2?U%2Tw=w]~RBVZRi};RPxuwH"
)
```

### Caching Strategy

The `ImageCacheManager` automatically handles saving and retrieving images from both Memory and Disk.

```swift
// Clear all caches
ImageCacheManager.shared.clear()
```

### Image Processing

You can compress or resize images easily using `ImageProcessor`.

```swift
let image = UIImage(named: "large_photo")!

// Compress to roughly 50KB
if let compressedData = ImageProcessor.compress(image, targetBytes: 50_000) {
    // Upload data...
}

// Resize image
if let thumbnail = ImageProcessor.resize(image, to: CGSize(width: 100, height: 100)) {
    // Use thumbnail...
}
```

## License

This project is licensed under the MIT License.
