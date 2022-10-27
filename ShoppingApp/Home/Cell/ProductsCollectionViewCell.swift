//
//  ProductsCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 25/10/2022.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setProductName(productName: String) {
            productNameLabel.text = productName
        }
    
    func setProductPrice(price: String) {
            priceLabel.text = "\(price)$"
        }
    
    func setProductImage(image: String) {
        productImageView.image = UIImage(named: image)
        }
    
    var cornerRadius: CGFloat = 14

    override func awakeFromNib() {
        super.awakeFromNib()
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
    }
}
