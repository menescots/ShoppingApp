//
//  WishlistCustomCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 03/11/2022.
//

import UIKit

class WishlistCustomCell: UITableViewCell {
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    func setProductName(productName: String) {
            productNameLabel.text = productName
        }
    
    func setProductPrice(price: Int) {
            productPriceLabel.text = "\(String(price))$"
        }
    
    func setProductImage(image: String) {
        productImage.image = UIImage(named: image)
        }
    
    var cornerRadius: CGFloat = 14
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addToCartButton.layer.borderColor = UIColor.black.cgColor
        addToCartButton.layer.borderWidth = 1
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
    }
}
