//
//  CategoryCustomCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 24/10/2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var CategoryNameLabel: UILabel!
    
    func setLabelTitle(title:String) {
            CategoryNameLabel.text = title
        CategoryNameLabel.layer.masksToBounds = true
        CategoryNameLabel.layer.cornerRadius = 14
        }
    
    var cornerRadius: CGFloat = 14

    override func awakeFromNib() {
        super.awakeFromNib()
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        // Apply a shadow
//        layer.shadowRadius = 6.0
//        layer.shadowOpacity = 0.50
//        layer.shadowColor = UIColor(named: "shadowColor")!.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Improve scrolling performance with an explicit shadowPath
//        layer.shadowPath = UIBezierPath(
//            roundedRect: bounds,
//            cornerRadius: cornerRadius
//        ).cgPath
//    }
}
