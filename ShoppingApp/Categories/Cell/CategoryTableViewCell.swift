//
//  CategoryCustomCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 24/10/2022.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryContentLabel: UILabel!
    let categoryNames = ["electronics", "man", "woman", "baby", "kids" ]
    var cornerRadius: CGFloat = 20

    func setCategoryName(name: String) {
        categoryNameLabel.text = name
    }
    
    func setCategoryContent(content: String){
        categoryContentLabel.text = content
    }
    
    func setCategoryImage(index: Int) {
        categoryImage.image = UIImage(named: categoryNames[index])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
}
