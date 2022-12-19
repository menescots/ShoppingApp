//
//  ShoppingCartViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 07/11/2022.
//

import UIKit
import CoreData
import FirebaseDatabase
class ShoppingCartViewController: UIViewController, Alertable {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productTableView: UITableView!
    var cartProducts = [Product]()
    var totalPrice = 0
    private let database = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        productTableView.delegate = self
        productTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProducts()
       
    }
    
    @IBAction func addToWishlist(_ sender: Any) {
        guard let indexPath = productTableView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! ShoppingCartCustomCell)) else { return }
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
        let wishlistProduct = [
            "isSelected": true
        ]
        let product = cartProducts[indexPath.row]
        self.database.child("users").child(safeEmail).child("Wishlist").child("\(product.id)").setValue(wishlistProduct, withCompletionBlock: { [weak self] error,_  in
            guard error == nil else { return }
            self?.addRemoveCartAlert(message: "Product added to wishlist")
        })
        removeFromCart(sender)
        updateTotal()
    }
    @IBAction func removeFromCart(_ sender: Any) {
        guard let indexPath = productTableView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! ShoppingCartCustomCell)) else { return }
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
        let product = cartProducts[indexPath.row]
        self.database.child("users").child(safeEmail).child("Cart").child(String(product.id)).removeValue()
        self.cartProducts.remove(at: indexPath.row)
        self.productTableView.deleteRows(at: [indexPath], with: .fade)
        updateTotal()
    }
    func getProducts() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        self.database.child("users").child(safeEmail).child("Cart").observeSingleEvent(of: .value , with: { [weak self] snapshot in
            if let data = snapshot.value as? [String: [String: Any]] {
                var cartProductsIds = [Int]()
                for datum in data {
                    guard let amount = datum.value["amount"] as? Int,
                          let key = Int(datum.key) else { return }
                    
                    cartProductsIds.append(key)
                    var productId = (Int(datum.key) ?? 201) - 201
                    print(cartProductsIds)
                    self?.database.child("Products/\(productId)").observeSingleEvent(of: .value, with: { [self] snapshot in
                        if let product = snapshot.value as? [String: Any] {
                            
                                guard let name = product["name"] as? String,
                                      let price = product["price"] as? Int,
                                      let id = product["id"] as? Int,
                                      let categoryId = product["categoryId"] as? Int,
                                      let content = product["content"] as? String else {
                                    return
                                }
                                if (self?.cartProducts.contains(where: {$0.id == id}))! { return }

                                if id == Int(datum.key){
                                    let prod = Product(id: id, name: name, price: price, categoryId: categoryId, content: content, imageUrl: nil, amount: amount)
                                    self?.cartProducts.append(prod)
                                    self?.productTableView.reloadData()
                                }
                        }
                    })
                    self?.productTableView.reloadData()
                }
            }
        })
    }
    @objc func refresh(notification: Notification) {
        if let dict = notification.object as? NSDictionary {
                if let id = dict["id"] as? Int{
                    cartProducts.removeAll(where: { $0.id == id})
                }
            }
       self.productTableView.reloadData()
   }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath as IndexPath) as! ShoppingCartCustomCell
        let product = cartProducts[indexPath.row]
        updateTotal()
        cell.configure(name: product.name, quantity: Int(product.amount!), unitPrice: Int(product.price), delegate: self)
        cell.setProductImage(image: "imageproduct")
        cell.setProductID(id: Int(product.id))
        return cell
    }
    
    
}

extension ShoppingCartViewController: ShoppingItemCellDelegate {
    func cell(_ cell: ShoppingCartCustomCell, didUpdateQuantity quantity: Int) {
        guard let indexPath = productTableView.indexPath(for: cell) else { return }
        var product = cartProducts[indexPath.row]
        product.amount = quantity

        updateTotal()
    }
}

private extension ShoppingCartViewController {
    func updateTotal() {
        let total = cartProducts
            .map { $0.amount! * $0.price }
            .reduce(0, +)

        totalPriceLabel.text = String(total)
    }
}
