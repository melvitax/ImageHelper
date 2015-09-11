//
//  AFImageExtension.swift
//
//  AFImageHelper
//  Version 2.0.0
//
//  Created by Melvin Rivera on 7/5/14.
//  Copyright (c) 2014 All Forces. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreGraphics


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
    
    :param: color :UIColor The color to fill the image with.
    :param: size :CGSize Image size (defaults: 10x10)
    
    :returns: UIImage
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
    
    :param: gradientColors :[UIColor] The colors to use for the gradient.
    :param: size :CGSize Image size (defaults: 10x10)
    
    :returns: A new UIImage
    */
    convenience init?(gradientColors:[UIColor], size:CGSize = CGSizeMake(10, 10) )
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject! in return color.CGColor as AnyObject! } as NSArray
        let gradient = CGGradientCreateWithColors(colorSpace, colors, nil)
        CGContextDrawLinearGradient(context, gradient, CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height), CGGradientDrawingOptions(rawValue: 0))
        self.init(CGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage!)
        UIGraphicsEndImageContext()
    }
    
    /**
    Applies gradient color overlay to an image.
    
    :param: gradientColors :[UIColor] The colors to use for the gradient.
    :param: blendMode :CGBlendMode The blending type to use.
    
    :returns: A new UIImage
    */
    func applyGradientColors(gradientColors: [UIColor], blendMode: CGBlendMode = CGBlendMode.Normal) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        CGContextDrawImage(context, rect, self.CGImage)
        // Create gradient
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject! in return color.CGColor as AnyObject! } as NSArray
        let gradient = CGGradientCreateWithColors(colorSpace, colors, nil)
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
    
    :param: text :String The text to use in the label.
    :param: font :UIFont The font (default: System font of size 18)
    :param: color :UIColor The text color (default: White)
    :param: backgroundColor :UIColor The background color (default:Gray).
    :param: size :CGSize Image size (default: 10x10)
    :param: offset :CGPoint Center offset (default: 0x0)
    
    :returns: A new UIImage
    */
    convenience init?(text: String, font: UIFont = UIFont.systemFontOfSize(18), color: UIColor = UIColor.whiteColor(), backgroundColor: UIColor = UIColor.grayColor(), size:CGSize = CGSizeMake(100, 100), offset: CGPoint = CGPoint(x: 0, y: 0))
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
        CGContextFillRect(context, CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let style = NSMutableParagraphStyle()
        style.alignment = .Center
        let attr = [NSFontAttributeName:font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName:style]
        let rect = CGRect(x: offset.x, y: offset.y, width: size.width, height: size.height)
        text.drawInRect(rect, withAttributes: attr)
        self.init(CGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage!)
        UIGraphicsEndImageContext()
    }
    
    // MARK: Image from uiview
    /**
    Creates an image from a View.
    
    :param: fromView :UIView The source view.
    
    :returns: A new UIImage
    */
    convenience init?(fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        //view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        self.init(CGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage!)
        UIGraphicsEndImageContext()
    }
    
    // MARK: Image with Radial Gradient
    /**
    Creates a radial gradient.
    
    :param: startColor :UIColor The start color
    :param: endColor :UIColor The end color
    :param: radialGradientCenter :CGPoint The gradient center (default:0.5,0.5).
    :param: radius :CGPoint Radius size (default: 0.5)
    :param: size :CGSize Image size (default: 100x100)
    
    :returns: A new UIImage
    :discussion: Radial background originally from: http://developer.apple.com/library/ios/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadings/dq_shadings.html
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

    :returns: Bool
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
    
    :returns: UIImage?
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
    
    :param: padding :CGFloat The padding amount.
    
    :returns: UIImage?
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
    
    :param: padding :CGFloat The padding amount.
    :param: size :CGSize The size of the image.
    
    :returns: CGImageRef
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
    
    :param: bounds :CGRect The bounds of the rectangle inside the image.
    
    :returns: UIImage?
    */
    func crop(bounds: CGRect) -> UIImage?
    {
        return UIImage(CGImage: CGImageCreateWithImageInRect(self.CGImage, bounds)!)
    }
    
    func cropToSquare() -> UIImage? {
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
    
    :param: size :CGSize The new size of the image.
    :param: contentMode :UIImageContentMode The way to handle the content in the new size.
    
    :returns: UIImage?
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
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width * ratio, height: self.size.height * ratio)
        
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
        let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        return newImage;
    }

    
    // MARK: Corner Radius
    
    /**
    Creates a new image with rounded corners.
    
    :param: cornerRadius :CGFloat The corner radius.
    
    :returns: UIImage?
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
        let rect = CGRect(x: 0, y: 0, width: size.width*scale, height: size.height*scale)
        
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
    
    :param: cornerRadius :CGFloat The corner radius.
    :param: border :CGFloat The size of the border.
    :param: color :UIColor The color of the border.
    
    :returns: UIImage?
    */
    func roundCorners(cornerRadius:CGFloat, border:CGFloat, color:UIColor) -> UIImage?
    {
        return roundCorners(cornerRadius)?.applyBorder(border, color: color)
    }
    
    /**
    Creates a new circle image.
    
    :returns: UIImage?
    */
    func roundCornersToCircle() -> UIImage?
    {
        let shortest = min(size.width, size.height)
        return cropToSquare()?.roundCorners(shortest/2)
    }
    
    /**
    Creates a new circle image with a border.
    
    :param: border :CGFloat The size of the border.
    :param: color :UIColor The color of the border.
    
    :returns: UIImage?
    */
    func roundCornersToCircle(border border:CGFloat, color:UIColor) -> UIImage?
    {
        let shortest = min(size.width, size.height)
        return cropToSquare()?.roundCorners(shortest/2, border: border, color: color)
    }
    
    // MARK: Border
    
    /**
    Creates a new image with a border.
    
    :param: border :CGFloat The size of the border.
    :param: color :UIColor The color of the border.
    
    :returns: UIImage?
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
    
    // MARK: Image From URL
    
    /**
    Creates a new image from a URL with optional caching.
    
    :param: url :String The image URL.
    :param: placeholder :UIImage The placeholder image.
    :param: shouldCacheImage :Bool Weather or not we should cache the NSURL response (default: true)
    :param: closure :(image: UIImage?) The image from the web the first time is fetched.
    
    :returns: UIImage?
    :discussion: If cached, the cached image is returned. Otherwise, a place holder is used until the image from web is returned by the closure.
    */
    class func imageFromURL(url: String, placeholder: UIImage, shouldCacheImage: Bool = true, closure: (image: UIImage?) -> ()) -> UIImage?
    {
        // From Cache
        if shouldCacheImage {
            if UIImage.sharedCache().objectForKey(url) != nil {
                closure(image: nil)
                return UIImage.sharedCache().objectForKey(url) as! UIImage!
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
                if let image = UIImage(data: data!) {
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