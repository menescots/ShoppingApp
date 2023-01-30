//
//  ShoppingCartCustomCell.swift
//  ShoppingApp
//
//  Created by Agata Menes on 09/11/2022.
//

import UIKit
import FirebaseDatabase

class ShoppingCartCustomCell: UITableViewCell {
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    var productPrice = 0
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productIdLabel: UILabel!
    private let database = Database.database().reference()
    private var productId: Int!
    @IBAction func productAmountChanged(_ sender: UIStepper) {
        let quantity = Int(sender.value)
        productAmount.text = String(quantity)
        let cartProduct = [
            "amount": quantity
        ]
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        self.database.child("users").child(safeEmail).child("Cart").child(String(productId)).setValue(cartProduct, withCompletionBlock: { [weak self] error,_  in
            guard error == nil else { return }
            
        })
    }
                                                                                                           
    func configureCell(name: String, image: String, id: Int, amount: Int, price: Int) {
        productId = id
        productImage.image = UIImage(named: image)
        productIdLabel.text = "ID: \(String(id))"
        productName.text = name
        productPriceLabel.text = "\(price)$"
        productAmount.text = "\(amount)"
    }
    
    let cornerRadius = 14.0
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
    }
}

