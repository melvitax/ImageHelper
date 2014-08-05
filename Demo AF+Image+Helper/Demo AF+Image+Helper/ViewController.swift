//
//  ViewController.swift
//  Swift Demo UIImage+AF+Additions
//
//  Created by Melvin Rivera on 7/5/14.
//  Copyright (c) 2014 All Forces. All rights reserved.
//

import UIKit
import CoreImage

enum ImageType: Int {
    case FromURL, SolidColor, GradientColor, GradientOverlay, RadialGradient, Text, Circle, CirclePlusBorder, RoundCorners, CropPlusResize, FromView
}

class Cell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
}

class ViewController: UICollectionViewController {
    
    let sections = ["Web Image", "Colors and Gradients", "Text", "Rounded Edges & Borders", "Cropping", "Screenshot"]
    let items: [[ImageType]] = [
        [.FromURL],
        [.SolidColor, .GradientColor, .GradientOverlay, .RadialGradient],
        [.Text],
        [.Circle, .CirclePlusBorder, .RoundCorners],
        [.CropPlusResize],
        [.FromView]
        ]
    let imageWidth = 140
    let imageHeight = 140
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int
    {
        return items.count
    }
    
    override func collectionView(collectionView: UICollectionView!, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> UICollectionReusableView! {
        
        let headerView:UICollectionReusableView! = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as UICollectionReusableView
        let textLabel = headerView.viewWithTag(1) as UILabel
        textLabel.text = sections[indexPath.section]
        return headerView
    }
    
    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
        return items[section].count
    }
    
    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
    {
        let cellID = "Cell"
        let cell:Cell! = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as Cell
        
        let item: ImageType = items[indexPath.section][indexPath.item]
        
        switch item {
            
            case .GradientColor:
                cell.imageView.image = UIImage(gradientColors: [UIColor(red: 0.808, green: 0.863, blue: 0.902, alpha: 1), UIColor(red: 0.349, green: 0.412, blue: 0.443, alpha: 1)], size: CGSize(width: imageWidth, height: imageHeight))
                cell.textLabel.text = "Gradient Color"
            
            case .GradientOverlay:
                cell.imageView.image = UIImage(named: "beach").applyGradientColors([UIColor(red: 0.996, green: 0.769, blue: 0.494, alpha: 1), UIColor(red: 0.969, green: 0.608, blue: 0.212, alpha: 0.2)])
                cell.textLabel.text = "Gradient Overlay"
            
            case .RadialGradient:
                cell.imageView.image = UIImage(startColor: UIColor(red: 0.996, green: 1, blue: 1, alpha: 1), endColor: UIColor(red: 0.627, green: 0.835, blue: 0.922, alpha: 1), radialGradientCenter: CGPoint(x: 0.5, y: 0.5), radius: 0.5, size: CGSize(width: imageWidth, height: imageHeight))
                cell.textLabel.text = "Radial Gradient"
            
            case .Text:
                cell.imageView.image = UIImage(text: "M", font: UIFont.systemFontOfSize(64), color: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), size: CGSize(width: imageWidth, height: imageHeight), offset: CGPoint(x: 0, y: 30))
                cell.textLabel.text = "Text Image"
            
            case .Circle:
                cell.imageView.image = UIImage(named: "beach").roundCornersToCircle()
                cell.textLabel.text = "Circle"
        
            case .CirclePlusBorder:
                cell.imageView.image = UIImage(named: "beach").roundCornersToCircle(border: 60, color: UIColor.grayColor())
                cell.textLabel.text = "Circle + Border"
            
            case .RoundCorners:
                cell.imageView.image = UIImage(named: "beach").roundCorners(12)
                cell.textLabel.text = "Round Corners"
            
            case .CropPlusResize:
                cell.imageView.image = UIImage(named: "beach").crop(CGRect(x: 40, y: 40, width: 320, height: 100)).applyPadding(6)
                cell.textLabel.text = "Crop + Resize"
            
            case .FromView:
                cell.imageView.image = UIImage(fromView: self.view).resize(CGSize(width: imageWidth, height: imageHeight), contentMode: .ScaleAspectFill)
                cell.textLabel.text = "From View"
            
            case .FromURL:
                cell.imageView.imageFromURL("https://c2.staticflickr.com/4/3212/3130969018_ed7516c288_n.jpg", placeholder: UIImage(color: UIColor.redColor(), size: CGSize(width: imageWidth, height: imageHeight)), fadeIn: true) {
                        (image: UIImage?) in
                        if image != nil {
                            cell.imageView.image = image!
                        }
                    }
                cell.textLabel.text = "From URL"
            
            default:
                cell.imageView.image = UIImage(color: UIColor(red: 0, green: 0.502, blue: 1, alpha: 1), size: CGSize(width: imageWidth, height: imageHeight))
                cell.textLabel.text = "Solid Color"
            
        }
        
        return cell
    }



}

