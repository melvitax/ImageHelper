//
//  ViewController.swift
//  AFImageHelper
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
    
    let imageWidth = 140 * UIScreen.mainScreen().scale
    let imageHeight = 140 * UIScreen.mainScreen().scale
    
    var sections = [String]()
    var items = [[CellItem]]()
    
    override func viewDidLoad() {
        
        // Core Image
        
        // Colors & Gradients
        sections.append("Colors & Gradients")
        var colors = [CellItem]()
        if let image = UIImage(color: UIColor(red: 0.0, green: 0.502, blue: 1.0, alpha: 1.0), size: CGSize(width: imageWidth, height: imageHeight)) {
            colors.append(CellItem(text: "Solid Color", image: image))
        }
        if let image = UIImage(gradientColors: [UIColor(red: 0.808, green: 0.863, blue: 0.902, alpha: 1.0), UIColor(red: 0.349, green: 0.412, blue: 0.443, alpha: 1.0)], size: CGSize(width: imageWidth, height: imageHeight)) {
            colors.append(CellItem(text: "Gradient Color", image: image))
        }
        if let image = UIImage(named: "beach")?.applyGradientColors([UIColor(red: 0.996, green: 0.769, blue: 0.494, alpha: 1.0), UIColor(red: 0.969, green: 0.608, blue: 0.212, alpha: 0.2)]) {
            colors.append(CellItem(text: "Gradient Overlay", image: image))
        }
        if let image = UIImage(startColor: UIColor(red: 0.996, green: 1.0, blue: 1.0, alpha: 1.0), endColor: UIColor(red: 0.627, green: 0.835, blue: 0.922, alpha: 1.0), radialGradientCenter: CGPoint(x: 0.5, y: 0.5), radius: 0.5, size: CGSize(width: imageWidth, height: imageHeight)) {
            colors.append(CellItem(text: "Radial Gradient", image: image))
        }
        items.append(colors)
       
        
        // Text
        sections.append("Text")
        var text = [CellItem]()
        let textSize = 64 * UIScreen.mainScreen().scale
        if let image = UIImage(text: "M", font: UIFont.systemFontOfSize(textSize), color: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), size: CGSize(width: imageWidth, height: imageHeight))?.roundCornersToCircle() {
            text.append(CellItem(text: "Text Image", image: image))
        }
        items.append(text)
    
        // Rounded Edges & Borders
        sections.append("Rounded Edges & Borders")
        var corners = [CellItem]()
        if let image = UIImage(named: "beach")?.roundCornersToCircle() {
            corners.append(CellItem(text: "Circle", image: image))
        }
        let border = 12 * UIScreen.mainScreen().scale
        if let image = UIImage(named: "beach")?.roundCornersToCircle(border: border, color: UIColor.lightGrayColor()) {
            corners.append(CellItem(text: "Circle + Border", image: image))
        }
        if let image = UIImage(named: "beach")?.roundCorners(12) {
            corners.append(CellItem(text: "Round Corners", image: image))
        }
        items.append(corners)
    
        
        // Cropping
        sections.append("Cropping")
        var cropping = [CellItem]()
        if let image = UIImage(named: "beach")?.crop(CGRect(x: 40.0, y: 40.0, width: imageWidth, height: imageHeight/2)) {
            cropping.append(CellItem(text: "Crop + Resize", image: image))
        }
        items.append(cropping)
    
        // Web Image
        sections.append("Web Image")
        var web = [CellItem]()
        if let image = UIImage(color: UIColor.redColor()) {
            web.append(CellItem(text: "From URL", image: image))
        }
        items.append(web)
        
       super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView:UICollectionReusableView! = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) 
        let textLabel = headerView.viewWithTag(1) as! UILabel
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
        let cell:Cell! = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! Cell
        
        let item: CellItem = items[indexPath.section][indexPath.item]
        cell.textLabel.text = item.text
        
        
        // Last image is a web request
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

