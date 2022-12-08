//
//  WishlistViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 03/11/2022.
//

import UIKit
import CoreData

class WishlistViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    
    var wishlistProducts = [Wishlist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.dataSource = self
        productsTableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProducts()
    }
   
    @IBAction func removeFromWishlist(_ sender: Any) {
        guard let indexPath = productsTableView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! WishlistCustomCell)) else { return }
        
        AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(self.wishlistProducts[indexPath.row])
        self.wishlistProducts.remove(at: indexPath.row)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        self.productsTableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    @IBAction func addToCart(_ sender: Any) {
        guard let indexPath = productsTableView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! WishlistCustomCell)) else { return }
        let product = wishlistProducts[indexPath.row]
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        
        let cartProduct = ShoppingCart(context: managedContext)
        
        cartProduct.setValue(product.name, forKey: #keyPath(ShoppingCart.name))
        cartProduct.setValue(product.price, forKey: #keyPath(ShoppingCart.price))
        cartProduct.setValue(product.productId, forKey: #keyPath(ShoppingCart.productId))
        cartProduct.setValue(product.image, forKey: #keyPath(ShoppingCart.image))
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        removeFromWishlist(sender)
    }
    
    func getProducts() {
        let productFetch: NSFetchRequest<Wishlist> = Wishlist.fetchRequest()
        
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(productFetch)
            wishlistProducts = results
            productsTableView.reloadData()
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(self.wishlistProducts[indexPath.row])
            self.wishlistProducts.remove(at: indexPath.row)
            // Save Changes
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            // Remove row from TableView
            self.productsTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
