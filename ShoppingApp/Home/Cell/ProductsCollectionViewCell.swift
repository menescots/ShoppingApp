//
//  ProductsCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 25/10/2022.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    var wishlistHeart = false
    var indexPath: IndexPath!
    
    func setProductName(productName: String) {
            productNameLabel.text = productName
        }
    
    func setProductPrice(price: Int) {
            priceLabel.text = "\(String(price))$"
        }
    
    func setProductImage(image: String) {
        productImageView.image = UIImage(named: image)
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     //   wishlistButton.addTarget(self, action: #selector(wishlistTapped(sender: )), for: .valueChanged)
    }
    var cornerRadius: CGFloat = 14

//    @objc func wishlistTapped(sender: UIButton) {
//            wishlistHeart = !wishlistHeart
//            delegate?.wishlistTrigger(row: indexPath.row)
//            if wishlistHeart == true {
//                wishlistButton.setImage(UIImage(named: "heartFilled"), for: .normal)
//            }else if wishlistHeart == false {
//                wishlistButton.setImage(UIImage(named: "heart"), for: .normal)
//
//            }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
    }
}
