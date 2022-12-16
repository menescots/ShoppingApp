//
//  ShoppingCartCustomCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 09/11/2022.
//

import UIKit

protocol ShoppingItemCellDelegate: AnyObject {
    func cell(_ cell: ShoppingCartCustomCell, didUpdateQuantity quantity: Int)
}

class ShoppingCartCustomCell: UITableViewCell {
    weak var delegate: ShoppingItemCellDelegate?
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    var productPrice = 0
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productIdLabel: UILabel!
    
    
    @IBAction func productAmountChanged(_ sender: UIStepper) {
        let quantity = Int(sender.value)
        productAmount.text = String(quantity)
        delegate?.cell(self, didUpdateQuantity: quantity)
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
extension ShoppingCartCustomCell {
    func configure(name: String, quantity: Int, unitPrice: Int, delegate: ShoppingItemCellDelegate) {
        self.delegate = delegate
print(name)
        productName.text = name
        productAmount.text = String(quantity)
        productPriceLabel.text = String(unitPrice)
    }
}
