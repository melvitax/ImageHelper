//
//  AFImageViewExtension.swift
//
//  AFImageHelper
//  Version 3.0.2
//
//  Created by Melvin Rivera on 7/23/14.
//  Copyright (c) 2014 All Forces. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public extension UIImageView {
    
    /**
    Loads an image from a URL. If cached, the cached image is returned. Otherwise, a place holder is used until the image from web is returned by the closure.
    
    - Parameter url: The image URL.
    - Parameter placeholder: The placeholder image.
    - Parameter fadeIn: Weather the mage should fade in.
    - Parameter closure: Returns the image from the web the first time is fetched.
    
    - Returns A new image
    */
    func imageFromURL(url: String, placeholder: UIImage, fadeIn: Bool = true, shouldCacheImage: Bool = true, closure: ((image: UIImage?) -> ())? = nil)
    {
        self.image = UIImage.imageFromURL(url, placeholder: placeholder, shouldCacheImage: shouldCacheImage) {
            (image: UIImage?) in
            if image == nil {
                return
            }
            if fadeIn {
                let crossFade = CABasicAnimation(keyPath: "contents")
                crossFade.duration = 0.5
                crossFade.fromValue = self.image?.CIImage
                crossFade.toValue = image!.CGImage
                self.layer.addAnimation(crossFade, forKey: "")
            }
            if let foundClosure = closure {
                foundClosure(image: image)
            }
            self.image = image
        }
    }
    
    
}
 