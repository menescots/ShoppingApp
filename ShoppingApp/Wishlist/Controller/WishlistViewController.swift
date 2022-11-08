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
    
    var wishlistProducts = [ShoppingApp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.dataSource = self
        productsTableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("in will appear")
        getProducts()
    }
   
    func getProducts() {
        let productFetch: NSFetchRequest<ShoppingApp> = ShoppingApp.fetchRequest()
        
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(productFetch)
            print(results)
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
    
    
}
