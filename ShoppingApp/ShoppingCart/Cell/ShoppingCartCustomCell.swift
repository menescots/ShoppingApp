//
//  ShoppingCartCustomCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 09/11/2022.
//

import UIKit

class ShoppingCartCustomCell: UITableViewCell {
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    var productPrice = 0
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productIdLabel: UILabel!
    
    
    @IBAction func productAmountChanged(_ sender: UIStepper) {
        let stepperValue = Int(sender.value)
        productAmount.text = String(stepperValue)
        productPriceLabel.text = String(stepperValue * productPrice) + "$"
    }
    func setProductName(name: String) {
        productName.text = name
    }
    
    func setProductPrice(price: Int){
        productPriceLabel.text = "\(String(price))$"
        productPrice = price
    }
    
    func setProductImage(image: String) {
        productImage.image = UIImage(named: image)
    }
    
    func setProductID(id: Int) {
        productIdLabel.text = "ID: \(String(id))"
    }

    func setProductAmount() {
        productAmount.text = String(1)
        stepper.value = 1
    }
    let cornerRadius = 14.0
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
    }
}
