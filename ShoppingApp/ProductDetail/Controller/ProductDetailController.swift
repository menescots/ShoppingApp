//
//  ProductDetailController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 12/12/2022.
//

import UIKit
import FirebaseDatabase
class ProductDetailController: UIViewController, Alertable {
    private let database = Database.database().reference()
    @IBOutlet weak var productNameLabel: UILabel!
    var product: Product?
    
    @IBOutlet weak var productDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let name = product?.name,
              let desc = product?.content else {
            return
        }
        productNameLabel.text = name
        productDescription.text = desc
    }
    
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        let cartProduct = [
            "amount": 1
        ]
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,
        let id = product?.id else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
        isInCart(id: id, completion: { exists in
            if !exists {
                self.database.child("users").child(safeEmail).child("Cart").child("\(id)").setValue(cartProduct, withCompletionBlock: { [weak self] error,_  in
                    guard error == nil else { return }
                    self?.addRemoveCartAlert(message: "Product added to cart")
                })
            } else {
                self.database.child("users").child(safeEmail).child("Cart").child("\(id)").removeValue(completionBlock: { error,_  in
                    guard error == nil else { return }
                    let info = ["id" : id]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: info)
                    self.addRemoveCartAlert(message: "Product removed from cart")
                })
            }
        })
    }

func isInCart(id: Int, completion: @escaping (Bool) -> Void) {
    guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
    let safeEmail = DatabaseManager.shared.safeEmail(email: email)
    
    self.database.child("users").child(safeEmail).child("Cart").child(String(id)).observeSingleEvent(of: .value, with: { snapshot in
        if !snapshot.exists() {
            completion(false)
        } else {
            completion(true)
        }
    })
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
