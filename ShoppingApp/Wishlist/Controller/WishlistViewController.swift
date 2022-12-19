//
//  WishlistViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 03/11/2022.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase
class WishlistViewController: UIViewController, Alertable {

    @IBOutlet weak var productsTableView: UITableView!
    private let database = Database.database().reference()
    var wishlistProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newWishlistProduct"), object: nil)
        productsTableView.dataSource = self
        productsTableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProducts()
    }
   
    @IBAction func removeFromWishlist(_ sender: Any) {
        guard let indexPath = productsTableView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! WishlistCustomCell)) else { return }
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
        let product = wishlistProducts[indexPath.row]
        self.database.child("users").child(safeEmail).child("Wishlist").child(String(product.id)).removeValue()
        self.wishlistProducts.remove(at: indexPath.row)
        self.productsTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        guard let indexPath = productsTableView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! WishlistCustomCell)) else { return }
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
        let cartProduct = [
            "amount": 1
        ]
        let product = wishlistProducts[indexPath.row]
        self.database.child("users").child(safeEmail).child("Cart").child("\(product.id)").setValue(cartProduct, withCompletionBlock: { [weak self] error,_  in
            guard error == nil else { return }
            self?.addRemoveCartAlert(message: "Product added to cart")
        })
        removeFromWishlist(sender)
    }
    
    func getProducts() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        self.database.child("users").child(safeEmail).child("Wishlist").observeSingleEvent(of: .value , with: { [weak self] snapshot in
            if let data = snapshot.value as? [String: [String: Any]] {
                var cartProductsIds = [Int]()
                for datum in data {
                    guard let amount = datum.value["isSelected"] as? Bool,
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
                                if (self?.wishlistProducts.contains(where: {$0.id == id}))! { return }

                                if id == Int(datum.key){
                                    let prod = Product(id: id, name: name, price: price, categoryId: categoryId, content: content, imageUrl: nil, amount: nil)
                                    self?.wishlistProducts.append(prod)
                                    self?.productsTableView.reloadData()
                                }
                        }
                    })
                    self?.productsTableView.reloadData()
                }
            }
        })
    }

    @objc func refresh(notification: Notification) {
        if let dict = notification.object as? NSDictionary {
                if let id = dict["id"] as? Int{
                    wishlistProducts.removeAll(where: { $0.id == id})
                }
            }
       self.productsTableView.reloadData()
   }
    func checkIfLogged(){
        FirebaseAuth.Auth.auth().addStateDidChangeListener { auth ,user in
            if user == nil {
                
            }
        }
    }
}

extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "wishlistCell") as! WishlistCustomCell
        
        let wishlistedProduct = wishlistProducts[indexPath.row]
        
        cell.setProductName(productName: wishlistedProduct.name)
        cell.setProductPrice(price: Int(wishlistedProduct.price))
        cell.setProductImage(image: "imageproduct")
        return cell
    }
    
}
