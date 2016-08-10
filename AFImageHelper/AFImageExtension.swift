//
//  AFImageExtension.swift
//
//  AFImageHelper
//  Version 3.1.0
//
//  Created by Melvin Rivera on 7/5/14.
//  Copyright (c) 2014 All Forces. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreGraphics
import Accelerate


public enum UIImageContentMode {
    case ScaleToFill, ScaleAspectFit, ScaleAspectFill
}


public extension UIImage {
    
    /**
     A singleton shared NSURL cache used for images from URL
     */
    private class func sharedCache() -> NSCache!
    {
        struct StaticSharedCache {
            static var sharedCache: NSCache? = nil
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&StaticSharedCache.onceToken) {
            StaticSharedCache.sharedCache = NSCache()
        }
        return StaticSharedCache.sharedCache!
    }
    
    // MARK: Image from solid color
    /**
     Creates a new solid color image.
     
     - Parameter color: The color to fill the image with.
     - Parameter size: Image size (defaults: 10x10)
     
     - Returns A new image
     */
    convenience init?(color:UIColor, size:CGSize = CGSizeMake(10, 10))
    {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        self.init(CGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage!)
        UIGraphicsEndImageContext()
    }
    
    // MARK:  Image from gradient colors
    /**
     Creates a gradient color image.
     
     - Parameter gradientColors: An array of colors to use for the gradient.
     - Parameter size: Image size (defaults: 10x10)
     
     - Returns A new image
     */
    convenience init?(gradientColors:[UIColor], size:CGSize = CGSizeMake(10, 10), locations: [Float] = [] )
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject! in return color.CGColor as AnyObject! } as NSArray
        var cgLocations: [CGFloat]! = nil
        if locations.count > 0 {
          cgLocations = locations.map { CGFloat($0) }
        }
        let gradient = CGGradientCreateWithColors(colorSpace, colors, cgLocations)
        CGContextDrawLinearGradient(context, gradient, CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height), CGGradientDrawingOptions(rawValue: 0))
        self.init(CGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage!)
        UIGraphicsEndImageContext()
    }

    /**
     Applies gradient color overlay to an image.

     - Parameter gradientColors: An array of colors to use for the gradient.
     - Parameter locations: An array of locations to use for the gradient.
     - Parameter blendMode: The blending type to use.

     - Returns A new image
     */
    func applyGradientColors(gradientColors: [UIColor], locations: [Float] = [], blendMode: CGBlendMode = CGBlendMode.Normal) -> UIImage
    {
      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      let context = UIGraphicsGetCurrentContext()
      CGContextTranslateCTM(context, 0, size.height)
      CGContextScaleCTM(context, 1.0, -1.0)
      CGContextSetBlendMode(context, blendMode)
      let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      CGContextDrawImage(context, rect, self.CGImage)
      // Create gradient
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      let colors = gradientColors.map {(color: UIColor) -> AnyObject! in return color.CGColor as AnyObject! } as NSArray
      var cgLocations: [CGFloat]! = nil
      if locations.count > 0 {
        cgLocations = locations.map { CGFloat($0) }
      }
      let gradient = CGGradientCreateWithColors(colorSpace, colors, cgLocations)
      // Apply gradient
      CGContextClipToMask(context, rect, self.CGImage)
      CGContextDrawLinearGradient(context, gradient, CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height), CGGradientDrawingOptions(rawValue: 0))
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext();
      return image;
    }

    // MARK: Image with Text
    /**
     Creates a text label image.

     - Parameter text: The text to use in the label.
     - Parameter font: The font (default: System font of size 18)
     - Parameter color: The text color (default: White)
     - Parameter backgroundColor: The background color (default:Gray).
     - Parameter size: Image size (default: 10x10)
     - Parameter offset: Center offset (default: 0x0)
     
     - Returns A new image
     */
    convenience init?(text: String, font: UIFont = UIFont.systemFontOfSize(18), color: UIColor = UIColor.whiteColor(), backgroundColor: UIColor = UIColor.grayColor(), size:CGSize = CGSizeMake(100, 100), offset: CGPoint = CGPoint(x: 0, y: 0))
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.font = font
        label.text = text
        label.textColor = color
        label.textAlignment = .Center
        label.backgroundColor = backgroundColor
        let image = UIImage(fromView: label)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.init(CGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage!)
        UIGraphicsEndImageContext()
    }
    
    // MARK: Image from UIView
    /**
     Creates an image from a UIView.
     
     - Parameter fromView: The source view.
     
     - Returns A new image
     */
    convenience init?(fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        //view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        self.init(CGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage!)
        UIGraphicsEndImageContext()
    }
    
    // MARK: Image with Radial Gradient
    // Radial background originally from: http://developer.apple.com/library/ios/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadings/dq_shadings.html
    /**
     Creates a radial gradient.
     
     - Parameter startColor: The start color
     - Parameter endColor: The end color
     - Parameter radialGradientCenter: The gradient center (default:0.5,0.5).
     - Parameter radius: Radius size (default: 0.5)
     - Parameter size: Image size (default: 100x100)
     
     - Returns A new image
     */
    convenience init?(startColor: UIColor, endColor: UIColor, radialGradientCenter: CGPoint = CGPoint(x: 0.5, y: 0.5), radius:Float = 0.5, size:CGSize = CGSizeMake(100, 100))
    {
        
        // Init
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        let num_locations: Int = 2
        let locations: [CGFloat] = [0.0, 1.0] as [CGFloat]
        
        let startComponents = CGColorGetComponents(startColor.CGColor)
        let endComponents = CGColorGetComponents(endColor.CGColor)
        
        let components: [CGFloat] = [startComponents[0], startComponents[1], startComponents[2], startComponents[3], endComponents[0], endComponents[1], endComponents[2], endComponents[3]] as [CGFloat]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations)
        
        // Normalize the 0-1 ranged inputs to the width of the image
        let aCenter = CGPoint(x: radialGradientCenter.x * size.width, y: radialGradientCenter.y * size.height)
        let aRadius = CGFloat(min(size.width, size.height)) * CGFloat(radius)
        
        // Draw it
        CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), gradient, aCenter, 0, aCenter, aRadius, CGGradientDrawingOptions.DrawsAfterEndLocation)
        self.init(CGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage!)
        // Clean up
        UIGraphicsEndImageContext()
    }
    
    // MARK: Alpha
    
    /**
     Returns true if the image has an alpha layer.
     */
    func hasAlpha() -> Bool
    {
        let alpha = CGImageGetAlphaInfo(self.CGImage)
        switch alpha {
        case .First, .Last, .PremultipliedFirst, .PremultipliedLast:
            return true
        default:
            return false
            
        }
    }
    
    /**
     Returns a copy of the given image, adding an alpha channel if it doesn't already have one.
     */
    func applyAlpha() -> UIImage?
    {
        if hasAlpha() {
            return self
        }
        
        let imageRef = self.CGImage;
        let width = CGImageGetWidth(imageRef);
        let height = CGImageGetHeight(imageRef);
        let colorSpace = CGImageGetColorSpace(imageRef)
        
        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.ByteOrderDefault.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue)
        let offscreenContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, bitmapInfo.rawValue)
        
        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), imageRef)
        let imageWithAlpha = UIImage(CGImage: CGBitmapContextCreateImage(offscreenContext)!)
        return imageWithAlpha
    }
    
    /**
     Returns a copy of the image with a transparent border of the given size added around its edges. i.e. For rotating an image without getting jagged edges.
     
     - Parameter padding: The padding amount.
     
     - Returns A new image.
     */
    func applyPadding(padding: CGFloat) -> UIImage?
    {
        // If the image does not have an alpha layer, add one
        let image = self.applyAlpha()
        if image == nil {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width + padding * 2, height: size.height + padding * 2)
        
        // Build a context that's the same dimensions as the new size
        let colorSpace = CGImageGetColorSpace(self.CGImage)
        let bitmapInfo = CGImageGetBitmapInfo(self.CGImage)
        let bitsPerComponent = CGImageGetBitsPerComponent(self.CGImage)
        let context = CGBitmapContextCreate(nil, Int(rect.size.width), Int(rect.size.height), bitsPerComponent, 0, colorSpace, bitmapInfo.rawValue)
        
        // Draw the image in the center of the context, leaving a gap around the edges
        let imageLocation = CGRect(x: padding, y: padding, width: image!.size.width, height: image!.size.height)
        CGContextDrawImage(context, imageLocation, self.CGImage)
        
        // Create a mask to make the border transparent, and combine it with the image
        let transparentImage = UIImage(CGImage: CGImageCreateWithMask(CGBitmapContextCreateImage(context), imageRefWithPadding(padding, size: rect.size))!)
        return transparentImage
    }
    
    /**
     Creates a mask that makes the outer edges transparent and everything else opaque. The size must include the entire mask (opaque part + transparent border).
     
     - Parameter padding: The padding amount.
     - Parameter size: The size of the image.
     
     - Returns A Core Graphics Image Ref
     */
    private func imageRefWithPadding(padding: CGFloat, size:CGSize) -> CGImageRef
    {
        // Build a context that's the same dimensions as the new size
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.ByteOrderDefault.rawValue | CGImageAlphaInfo.None.rawValue)
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, colorSpace, bitmapInfo.rawValue)
        // Start with a mask that's entirely transparent
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // Make the inner part (within the border) opaque
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, CGRect(x: padding, y: padding, width: size.width - padding * 2, height: size.height - padding * 2))
        // Get an image of the context
        let maskImageRef = CGBitmapContextCreateImage(context)
        return maskImageRef!
    }
    
    
    // MARK: Crop
    
    /**
     Creates a cropped copy of an image.
     
     - Parameter bounds: The bounds of the rectangle inside the image.
     
     - Returns A new image
     */
    func crop(bounds: CGRect) -> UIImage?
    {
        return UIImage(CGImage: CGImageCreateWithImageInRect(self.CGImage, bounds)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }
    
    func cropToSquare() -> UIImage? {
        let size = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale)
        let shortest = min(size.width, size.height)
        let left: CGFloat = size.width > shortest ? (size.width-shortest)/2 : 0
        let top: CGFloat = size.height > shortest ? (size.height-shortest)/2 : 0
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let insetRect = CGRectInset(rect, left, top)
        return crop(insetRect)
    }
    
    // MARK: Resize
    
    /**
     Creates a resized copy of an image.
     
     - Parameter size: The new size of the image.
     - Parameter contentMode: The way to handle the content in the new size.
     
     - Returns A new image
     */
    func resize(size:CGSize, contentMode: UIImageContentMode = .ScaleToFill) -> UIImage?
    {
        let horizontalRatio = size.width / self.size.width;
        let verticalRatio = size.height / self.size.height;
        var ratio: CGFloat!
        
        switch contentMode {
        case .ScaleToFill:
            ratio = 1
        case .ScaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .ScaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)
        
        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(nil, Int(rect.size.width), Int(rect.size.height), 8, 0, colorSpace, bitmapInfo.rawValue)
        
        let transform = CGAffineTransformIdentity
        
        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(context, transform);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, CGInterpolationQuality(rawValue: 3)!)
        
        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))
        
        // Draw into the context; this scales the image
        CGContextDrawImage(context, rect, self.CGImage)
        
        // Get the resized image from the context and a UIImage
        let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }
    
    
    // MARK: Corner Radius
    
    /**
     Creates a new image with rounded corners.
     
     - Parameter cornerRadius: The corner radius.
     
     - Returns A new image
     */
    func roundCorners(cornerRadius:CGFloat) -> UIImage?
    {
        // If the image does not have an alpha layer, add one
        let imageWithAlpha = applyAlpha()
        if imageWithAlpha == nil {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width = CGImageGetWidth(imageWithAlpha?.CGImage)
        let height = CGImageGetHeight(imageWithAlpha?.CGImage)
        let bits = CGImageGetBitsPerComponent(imageWithAlpha?.CGImage)
        let colorSpace = CGImageGetColorSpace(imageWithAlpha?.CGImage)
        let bitmapInfo = CGImageGetBitmapInfo(imageWithAlpha?.CGImage)
        let context = CGBitmapContextCreate(nil, width, height, bits, 0, colorSpace, bitmapInfo.rawValue)
        let rect = CGRect(x: 0, y: 0, width: CGFloat(width)*scale, height: CGFloat(height)*scale)
        
        CGContextBeginPath(context)
        if (cornerRadius == 0) {
            CGContextAddRect(context, rect)
        } else {
            CGContextSaveGState(context)
            CGContextTranslateCTM(context, rect.minX, rect.minY)
            CGContextScaleCTM(context, cornerRadius, cornerRadius)
            let fw = rect.size.width / cornerRadius
            let fh = rect.size.height / cornerRadius
            CGContextMoveToPoint(context, fw, fh/2)
            CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1)
            CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1)
            CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1)
            CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1)
            CGContextRestoreGState(context)
        }
        CGContextClosePath(context)
        CGContextClip(context)
        
        CGContextDrawImage(context, rect, imageWithAlpha?.CGImage)
        let image = UIImage(CGImage: CGBitmapContextCreateImage(context)!, scale:scale, orientation: .Up)
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     Creates a new image with rounded corners and border.
     
     - Parameter cornerRadius: The corner radius.
     - Parameter border: The size of the border.
     - Parameter color: The color of the border.
     
     - Returns A new image
     */
    func roundCorners(cornerRadius:CGFloat, border:CGFloat, color:UIColor) -> UIImage?
    {
        return roundCorners(cornerRadius)?.applyBorder(border, color: color)
    }
    
    /**
     Creates a new circle image.
     
     - Returns A new image
     */
    func roundCornersToCircle() -> UIImage?
    {
        let shortest = min(size.width, size.height)
        return cropToSquare()?.roundCorners(shortest/2)
    }
    
    /**
     Creates a new circle image with a border.
     
     - Parameter border :CGFloat The size of the border.
     - Parameter color :UIColor The color of the border.
     
     - Returns UIImage?
     */
    func roundCornersToCircle(border border:CGFloat, color:UIColor) -> UIImage?
    {
        let shortest = min(size.width, size.height)
        return cropToSquare()?.roundCorners(shortest/2, border: border, color: color)
    }
    
    // MARK: Border
    
    /**
     Creates a new image with a border.
     
     - Parameter border: The size of the border.
     - Parameter color: The color of the border.
     
     - Returns A new image
     */
    func applyBorder(border:CGFloat, color:UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width = CGImageGetWidth(self.CGImage)
        let height = CGImageGetHeight(self.CGImage)
        let bits = CGImageGetBitsPerComponent(self.CGImage)
        let colorSpace = CGImageGetColorSpace(self.CGImage)
        let bitmapInfo = CGImageGetBitmapInfo(self.CGImage)
        let context = CGBitmapContextCreate(nil, width, height, bits, 0, colorSpace, bitmapInfo.rawValue)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        CGContextSetRGBStrokeColor(context, red, green, blue, alpha)
        CGContextSetLineWidth(context, border)
        let rect = CGRect(x: 0, y: 0, width: size.width*scale, height: size.height*scale)
        let inset = CGRectInset(rect, border*scale, border*scale)
        CGContextStrokeEllipseInRect(context, inset)
        CGContextDrawImage(context, inset, self.CGImage)
        let image = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: Image Effects
    
    /**
     Applies a light blur effect to the image
     
     - Returns New image or nil
     */
    func applyLightEffect() -> UIImage? {
        return applyBlur(30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
    }
    
    /**
     Applies a extra light blur effect to the image
     
     - Returns New image or nil
     */
    func applyExtraLightEffect() -> UIImage? {
        return applyBlur(20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
    }
    
    /**
     Applies a dark blur effect to the image
     
     - Returns New image or nil
     */
    func applyDarkEffect() -> UIImage? {
        return applyBlur(20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
    }
    
    /**
     Applies a color tint to an image
     
     - Parameter color: The tint color
     
     - Returns New image or nil
     */
    func applyTintEffect(tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = CGColorGetNumberOfComponents(tintColor.CGColor)
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        return applyBlur(10, tintColor: effectColor, saturationDeltaFactor: -1.0)
    }

    /**
     Applies a blur to an image based on the specified radius, tint color saturation and mask image
     
     - Parameter blurRadius: The radius of the blur.
     - Parameter tintColor: The optional tint color.
     - Parameter saturationDeltaFactor: The detla for saturation.
     - Parameter maskImage: The optional image for masking.
     
     - Returns New image or nil
     */
    func applyBlur(blurRadius:CGFloat, tintColor:UIColor?, saturationDeltaFactor:CGFloat, maskImage:UIImage? = nil) -> UIImage? {
        guard size.width > 0 && size.height > 0 && CGImage != nil else {
            return nil
        }
        if maskImage != nil {
            guard maskImage?.CGImage != nil else {
                return nil
            }
        }
        let imageRect = CGRect(origin: CGPointZero, size: size)
        var effectImage = self
        let hasBlur = blurRadius > CGFloat(FLT_EPSILON)
        let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > CGFloat(FLT_EPSILON)
        if (hasBlur || hasSaturationChange) {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let effectInContext = UIGraphicsGetCurrentContext()
            CGContextScaleCTM(effectInContext, 1.0, -1.0)
            CGContextTranslateCTM(effectInContext, 0, -size.height)
            CGContextDrawImage(effectInContext, imageRect, CGImage)
            
            var effectInBuffer = vImage_Buffer(
                data: CGBitmapContextGetData(effectInContext),
                height: UInt(CGBitmapContextGetHeight(effectInContext)),
                width: UInt(CGBitmapContextGetWidth(effectInContext)),
                rowBytes: CGBitmapContextGetBytesPerRow(effectInContext))
           
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
            let effectOutContext = UIGraphicsGetCurrentContext()
            
            var effectOutBuffer = vImage_Buffer(
                data: CGBitmapContextGetData(effectOutContext),
                height: UInt(CGBitmapContextGetHeight(effectOutContext)),
                width: UInt(CGBitmapContextGetWidth(effectOutContext)),
                rowBytes: CGBitmapContextGetBytesPerRow(effectOutContext))
            
            if hasBlur {
                let inputRadius = blurRadius * UIScreen.mainScreen().scale
                var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2.0 * M_PI)) / 4.0 + 0.5))
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](count: matrixSize, repeatedValue: 0)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        let outputContext = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(outputContext, 1.0, -1.0)
        CGContextTranslateCTM(outputContext, 0, -size.height)
        
        // Draw base image.
        CGContextDrawImage(outputContext, imageRect, self.CGImage)
        
        // Draw effect image.
        if hasBlur {
            CGContextSaveGState(outputContext)
            if let image = maskImage {
                CGContextClipToMask(outputContext, imageRect, image.CGImage);
            }
            CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)
            CGContextRestoreGState(outputContext)
        }
        
        // Add in color tint.
        if let color = tintColor {
            CGContextSaveGState(outputContext)
            CGContextSetFillColorWithColor(outputContext, color.CGColor)
            CGContextFillRect(outputContext, imageRect)
            CGContextRestoreGState(outputContext)
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage

    }
    
    
    // MARK: Image From URL
    
    /**
     Creates a new image from a URL with optional caching. If cached, the cached image is returned. Otherwise, a place holder is used until the image from web is returned by the closure.
     
     - Parameter url: The image URL.
     - Parameter placeholder: The placeholder image.
     - Parameter shouldCacheImage: Weather or not we should cache the NSURL response (default: true)
     - Parameter closure: Returns the image from the web the first time is fetched.
     
     - Returns A new image
     */
    class func imageFromURL(url: String, placeholder: UIImage, shouldCacheImage: Bool = true, closure: (image: UIImage?) -> ()) -> UIImage?
    {
        // From Cache
        if shouldCacheImage {
            if let image = UIImage.sharedCache().objectForKey(url) as? UIImage {
                closure(image: nil)
                return image
            }
        }
        // Fetch Image
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        if let nsURL = NSURL(string: url) {
            session.dataTaskWithURL(nsURL, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    dispatch_async(dispatch_get_main_queue()) {
                        closure(image: nil)
                    }
                }
                if let data = data, image = UIImage(data: data) {
                    if shouldCacheImage {
                        UIImage.sharedCache().setObject(image, forKey: url)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        closure(image: image)
                    }
                }
                session.finishTasksAndInvalidate()
            }).resume()
        }
        return placeholder
    }
    
}