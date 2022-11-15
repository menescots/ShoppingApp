//
//  CategoryCustomCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 24/10/2022.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CategoryNameLabel: UILabel!
    
    func setLabelTitle(title:String) {
            CategoryNameLabel.text = title
        CategoryNameLabel.layer.masksToBounds = true
        CategoryNameLabel.layer.cornerRadius = 14
        }
    
    var cornerRadius: CGFloat = 14

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
