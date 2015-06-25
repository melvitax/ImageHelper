//
//  AF+ImageView+Extension.swift
//
//  Version 1.04
//
//  Created by Melvin Rivera on 7/23/14.
//  Copyright (c) 2014 All Forces. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public extension UIImageView {
        
    func imageFromURL(url: String, placeholder: UIImage, fadeIn: Bool = true, closure: ((image: UIImage?) -> ())? = nil)
    {
        self.image = UIImage.imageFromURL(url, placeholder: placeholder, shouldCacheImage: true) {
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
 