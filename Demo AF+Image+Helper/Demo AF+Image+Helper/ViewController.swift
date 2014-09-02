//
//  ViewController.swift
//  Swift Demo UIImage+AF+Additions
//
//  Created by Melvin Rivera on 7/5/14.
//  Copyright (c) 2014 All Forces. All rights reserved.
//

import UIKit
import CoreImage

struct CellItem {
    let text: String
    let image: UIImage
}

class Cell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
}

class ViewController: UICollectionViewController {
    
    let imageWidth = 140
    let imageHeight = 140
    
    var sections = [String]()
    var items = [[CellItem]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Colors & Gradients
        sections.append("Colors & Gradients")
        items.append([
            CellItem(text: "Solid Color", image: UIImage(color: UIColor(red: 0, green: 0.502, blue: 1, alpha: 1), size: CGSize(width: imageWidth, height: imageHeight))),
            CellItem(text: "Gradient Color", image: UIImage(gradientColors: [UIColor(red: 0.808, green: 0.863, blue: 0.902, alpha: 1), UIColor(red: 0.349, green: 0.412, blue: 0.443, alpha: 1)], size: CGSize(width: imageWidth, height: imageHeight))),
            CellItem(text: "Gradient Overlay", image: UIImage(named: "beach").applyGradientColors([UIColor(red: 0.996, green: 0.769, blue: 0.494, alpha: 1), UIColor(red: 0.969, green: 0.608, blue: 0.212, alpha: 0.2)])),
            CellItem(text: "Radial Gradient", image: UIImage(startColor: UIColor(red: 0.996, green: 1, blue: 1, alpha: 1), endColor: UIColor(red: 0.627, green: 0.835, blue: 0.922, alpha: 1), radialGradientCenter: CGPoint(x: 0.5, y: 0.5), radius: 0.5, size: CGSize(width: imageWidth, height: imageHeight)))
            ])
        
        // Text
        sections.append("Text")
        items.append([
            CellItem(text: "Text Image", image: UIImage(text: "M", font: UIFont.systemFontOfSize(64), color: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), size: CGSize(width: imageWidth, height: imageHeight), offset: CGPoint(x: 0, y: 30)))
            ])
        
        // Rounded Edges & Borders
        sections.append("Rounded Edges & Borders")
        items.append([
            CellItem(text: "Circle", image: UIImage(named: "beach").roundCornersToCircle()),
            CellItem(text: "Circle + Border", image: UIImage(named: "beach").roundCornersToCircle(border: 60, color: UIColor.grayColor())),
            CellItem(text: "Round Corners", image: UIImage(named: "beach").roundCorners(12))
            ])
        
        // Cropping
        sections.append("Cropping")
        items.append([
            CellItem(text: "Crop + Resize", image: UIImage(named: "beach").crop(CGRect(x: 40, y: 40, width: 320, height: 100)).applyPadding(6))
            ])
        
        // Screenshot
        sections.append("Screenshot")
        items.append([
            CellItem(text: "From View", image: UIImage(fromView: self.view).resize(CGSize(width: imageWidth, height: imageHeight), contentMode: .ScaleAspectFill))
            ])
        
        // Web Image
        sections.append("Web Image")
        items.append([
            CellItem(text: "From URL", image: UIImage(color: UIColor.redColor()))
            ])
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView:UICollectionReusableView! = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as UICollectionReusableView
        let textLabel = headerView.viewWithTag(1) as UILabel
        textLabel.text = sections[indexPath.section]
        return headerView
    }
    
   
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return items[section].count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cellID = "Cell"
        let cell:Cell! = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as Cell
        
        let item: CellItem = items[indexPath.section][indexPath.item]
        cell.textLabel.text = item.text
        if (indexPath.section == items.count-1) {
            cell.imageView.imageFromURL("https://c2.staticflickr.com/4/3212/3130969018_ed7516c288_n.jpg", placeholder: item.image, fadeIn: true) {
                (image: UIImage?) in
                if image != nil {
                    cell.imageView.image = image!
                }
            }
        } else {
            cell.imageView.image = item.image
        }
        
        return cell
    }



}

