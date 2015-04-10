AF+Image+Helper 1.04
=============================

Convenience extension for UIImage and UIImageView in Swift
A collection of extensions for handling image creation from colors and gradients, cropping, scaling and fetching from the web with support for caching.

Works with Swift 1.2

![Sample Project Screenshot](Screenshot.png?raw=true "Sample Project Screenshot")


UIImageView Extension
=============================
### Image from a URL
```Swift
imageFromURL(url: String, placeholder: UIImage, fadeIn: Bool = true, closure: ((image: UIImage?) -> ())? = nil)
// Fetches an image from a URL. The cached image is returned if available, otherise the placeholder is set until the backaground fetch returns a proper image.
```

UIImage Extension
=============================

### Image from a URL
```Swift
UIImage.imageFromURL(url: String, placeholder: UIImage, shouldCacheImage: Bool = true, closure: (image: UIImage?) -> ()) -> UIImage?
// Fetches an image from a URL. If caching is set, it will be cached by NSCache for future queries. The cached image is returned if available, otherise the placeholder is set. When the image is returned, the closure gets called.
```

### Colors
```Swift
UIImage(color:UIColor, size:CGSize)
// Creates an image from a solid color
UIImage(gradientColors:[UIColor], size:CGSize) 
// Creates an image from a gradient color
func applyGradientColors(gradientColors: [UIColor], blendMode: CGBlendMode) -> UIImage 
// Applies a gradient overlay to an image
UIImage(startColor: UIColor, endColor: UIColor, radialGradientCenter: CGPoint, radius:Float, size:CGSize)
// Creates an image from a radial gradient
```

### Text
```Swift
UIImage(text: String, font: UIFont, color: UIColor, backgroundColor: UIColor, size:CGSize, offset: CGPoint)
// Creates an image with a string of text
```

### Screenshot
```Swift
UIImage(fromView view: UIView)
// Creates an image from a UIView 
```


### Alpha and Padding
```Swift
func hasAlpha() -> Bool
// Returns true if the image has an alpha layer
func applyAlpha() -> UIImage 
// Returns a copy(if needed) of the image with alpha layer 
func applyPadding(padding: CGFloat) -> UIImage 
// Returns a copy of the image with a transparent border of the given size added around its edges
func imageRefWithPadding(padding: CGFloat, size:CGSize) -> CGImageRef 
```

### Crop and Resize
```Swift
func crop(bounds: CGRect) -> UIImage 
// Crops an image to a new rect
func cropToSquare() -> UIImage 
// Crops an image to a centered square
func resize(size:CGSize, contentMode: UIImageContentMode = .ScaleToFill) -> UIImage 
// Resizes an image
```

### Circle and Rounded Corners
```Swift
func roundCorners(cornerRadius:CGFloat) -> UIImage
// Rounds corners of an image
func roundCorners(cornerRadius:CGFloat, border:CGFloat, color:UIColor) -> UIImage
// Rounds corners of an image with border
func roundCornersToCircle() -> UIImage
// Rounds corners to a circle
func roundCornersToCircle(#border:CGFloat, color:UIColor) -> UIImage
// Rounds corners to a circle with border
```

### Border
```Swift
func applyBorder(border:CGFloat, color:UIColor) -> UIImage {
// Adds a border
```
