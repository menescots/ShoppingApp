//
//  ShoppingCartViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 07/11/2022.
//

import UIKit
import CoreData

class ShoppingCartViewController: UIViewController {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productTableView: UITableView!
    var cartProducts = [ShoppingCart]()
  var totalPrice = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTableView.delegate = self
        productTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProducts()
    }
    
    @IBAction func addToWishlist(_ sender: Any) {
        guard let indexPath = productTableView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! ShoppingCartCustomCell)) else { return }
        
        let product = cartProducts[indexPath.row]
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        
        let wishlistedProduct = Wishlist(context: managedContext)
        
        wishlistedProduct.setValue(product.name, forKey: #keyPath(Wishlist.name))
        wishlistedProduct.setValue(product.price, forKey: #keyPath(Wishlist.price))
        wishlistedProduct.setValue(product.productId, forKey: #keyPath(Wishlist.productId))
        wishlistedProduct.setValue(product.image, forKey: #keyPath(Wishlist.image))
        removeFromCart(sender)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    @IBAction func removeFromCart(_ sender: Any) {
        guard let indexPath = productTableView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! ShoppingCartCustomCell)) else { return }

        AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(self.cartProducts[indexPath.row])
        self.cartProducts.remove(at: indexPath.row)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        self.productTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    func getProducts() {
        let productFetch: NSFetchRequest<ShoppingCart> = ShoppingCart.fetchRequest()
        
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(productFetch)
            print(results)
            cartProducts = results
            productTableView.reloadData()
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }


}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath as IndexPath) as! ShoppingCartCustomCell
        let product = cartProducts[indexPath.row]
        cell.setProductName(name: product.name)
        cell.setProductImage(image: "imageproduct")
        cell.setProductPrice(price: Int(product.price))
        cell.setProductID(id: Int(product.productId))
        cell.setProductAmount()
        return cell
    }
    
    
}
