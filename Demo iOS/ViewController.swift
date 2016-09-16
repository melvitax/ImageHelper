//
//  ViewController.swift
//  AFImageHelper
//
//  Created by Melvin Rivera on 7/5/14.
//  Copyright (c) 2014 All Forces. All rights reserved.
//

import Foundation
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
    
    let imageWidth = 140 * UIScreen.main.scale
    let imageHeight = 140 * UIScreen.main.scale
    
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
        if let image = UIImage(named: "beach")?.apply(gradientColors: [UIColor(red: 0.996, green: 0.769, blue: 0.494, alpha: 1.0), UIColor(red: 0.969, green: 0.608, blue: 0.212, alpha: 0.2)]) {
            colors.append(CellItem(text: "Gradient Overlay", image: image))
        }
        if let image = UIImage(named: "beach")?.apply(gradientColors: [UIColor.red, UIColor.green, UIColor.blue], locations: [0, 0.25, 0.99], blendMode: .normal) {
          colors.append(CellItem(text: "Gradient More", image: image))
        }
        if let image = UIImage(startColor: UIColor(red: 0.996, green: 1.0, blue: 1.0, alpha: 1.0), endColor: UIColor(red: 0.627, green: 0.835, blue: 0.922, alpha: 1.0), radialGradientCenter: CGPoint(x: 0.5, y: 0.5), radius: 0.5, size: CGSize(width: imageWidth, height: imageHeight)) {
            colors.append(CellItem(text: "Radial Gradient", image: image))
        }
        items.append(colors)
        
        
        // Text
        sections.append("Text")
        var text = [CellItem]()
        let textSize = 64 * UIScreen.main.scale
        if let image = UIImage(text: "M", font: UIFont.systemFont(ofSize: textSize), color: UIColor.white, backgroundColor: UIColor.red, size: CGSize(width: imageWidth, height: imageHeight))?.roundCornersToCircle() {
            text.append(CellItem(text: "Text Image", image: image))
        }
        items.append(text)
        
        // Rounded Edges & Borders
        sections.append("Rounded Edges & Borders")
        var corners = [CellItem]()
        if let image = UIImage(named: "beach")?.roundCornersToCircle() {
            corners.append(CellItem(text: "Circle", image: image))
        }
        let border = 12 * UIScreen.main.scale
        if let image = UIImage(named: "beach")?.roundCornersToCircle(withBorder: border, color: UIColor.lightGray) {
            corners.append(CellItem(text: "Circle + Border", image: image))
        }
        if let image = UIImage(named: "beach")?.roundCorners(cornerRadius: 12) {
            corners.append(CellItem(text: "Round Corners", image: image))
        }
        items.append(corners)
        
        
        // Cropping
        sections.append("Cropping")
        var cropping = [CellItem]()
        if let image = UIImage(named: "beach")?.crop(bounds: CGRect(x: 40.0, y: 40.0, width: imageWidth, height: imageHeight/2)) {
            cropping.append(CellItem(text: "Crop + Resize", image: image))
        }
        items.append(cropping)
        
        // Effects
        sections.append("Image Effects")
        var effects = [CellItem]()
        if let image = UIImage(named: "beach")?.applyDarkEffect() {
            effects.append(CellItem(text: "Dark Effect", image: image))
        }
        if let image = UIImage(named: "beach")?.applyLightEffect() {
            effects.append(CellItem(text: "Light Effect", image: image))
        }
        if let image = UIImage(named: "beach")?.applyExtraLightEffect() {
            effects.append(CellItem(text: "Extra Light Effect", image: image))
        }
        if let image = UIImage(named: "beach")?.applyTintEffect(tintColor: UIColor.red) {
            effects.append(CellItem(text: "Tint Effect", image: image))
        }
        if let image = UIImage(named: "beach")?.applyBlur(withRadius: 10, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8) {
            effects.append(CellItem(text: "Blur Effect", image: image))
        }
        items.append(effects)
        
        // Web Image
        sections.append("Web Image")
        var web = [CellItem]()
        if let image = UIImage(color: UIColor.red) {
            web.append(CellItem(text: "From URL", image: image))
        }
        items.append(web)
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView:UICollectionReusableView! = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) 
        let textLabel = headerView.viewWithTag(1) as! UILabel
        textLabel.text = sections[(indexPath as NSIndexPath).section]
        return headerView
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return items[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellID = "Cell"
        let cell:Cell! = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! Cell
        
        let item: CellItem = items[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).item]
        cell.textLabel.text = item.text
        
        
        // Last image is a web request
        if ((indexPath as NSIndexPath).section == items.count-1) {
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
