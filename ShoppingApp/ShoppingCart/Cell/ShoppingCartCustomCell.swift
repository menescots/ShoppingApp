//
//  ShoppingCartCustomCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 09/11/2022.
//

import UIKit

class ShoppingCartCustomCell: UITableViewCell {
        
    @IBOutlet weak var productName: UILabel!
        @IBOutlet weak var productImage: UIImageView!

    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var productIdLabel: UILabel!
    
    func setProductName(name: String) {
                productName.text = name
            }
        
        func setProductPrice(price: Int) {
                productPriceLabel.text = "\(String(price))$"
            }
        
        func setProductImage(image: String) {
            productImage.image = UIImage(named: image)
            }
    
    func setProductID(id: Int) {
        productIdLabel.text = "ID: \(String(id))"
        }
    let cornerRadius = 14.0
        override func awakeFromNib() {
            super.awakeFromNib()
            contentView.layer.cornerRadius = cornerRadius
            contentView.layer.masksToBounds = true
        }
}
