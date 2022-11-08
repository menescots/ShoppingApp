//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 24/10/2022.
//

import UIKit
import FacebookLogin
import FirebaseAuth
import CoreData
import SwiftyJSON
import FirebaseDatabase

class HomeViewController: UIViewController {

    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var UIStackView: UIStackView!
    private let database = Database.database().reference()
    var container: NSPersistentContainer!
    var categories = [Category]()
    var products = [Product]()
    var wishlistProducts = [ShoppingApp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionLayout()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        listenForProducts()
        listenForCategories()

    }
    
    @objc func listenForProducts() {
        database.child("Products").observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [[String: Any]] {
                for datum in data {
                    guard let name = datum["name"] as? String,
                    let price = datum["price"] as? Int,
                          let id = datum["id"] as? Int,
                          let categoryId = datum["categoryId"] as? Int,
                          let content = datum["content"] as? String else { print("returned"); return }
                    
                    self.products.append(Product(id: id, name: name, price: price, categoryId: categoryId, content: content, imageUrl: nil))
                    self.productsCollectionView.reloadData()
                }
            }
        })
    }
    
    @objc func listenForCategories() {
        database.child("Categories").observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [[String: Any]] {
                for datum in data {
                    guard let name = datum["name"] as? String,
                          let id = datum["id"] as? Int,
                          let content = datum["content"] as? String else { print("returned"); return }
                    
                    self.categories.append(Category(name: name, content: content, id: id))
                    self.categoryCollectionView.reloadData()
                }
            }
        })
    }
    
    @IBAction func addToWishlistButtonTapped(_ sender: Any) {
        guard let indexPath = productsCollectionView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! ProductsCollectionViewCell)) else { return }
        
        let product = products[indexPath.row]
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
          let wishlistedProduct = ShoppingApp(context: managedContext)
        wishlistedProduct.setValue(product.name, forKey: #keyPath(ShoppingApp.name))
        wishlistedProduct.setValue(product.price, forKey: #keyPath(ShoppingApp.price))
        wishlistedProduct.setValue(product.id, forKey: #keyPath(ShoppingApp.productId))
        wishlistedProduct.setValue(product.imageUrl, forKey: #keyPath(ShoppingApp.imageUrl))
          self.wishlistProducts.insert(wishlistedProduct, at: 0)
          AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
    }
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        
    }
    func setUpCollectionLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (width / 2)-20, height: (width / 2)+10)

        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        productsCollectionView.collectionViewLayout = layout
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView {
            return categories.count
        } else {
            return products.count
        }
   
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
            let category = categories[indexPath.row]
            cell.setLabelTitle(title: category.name )
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
            
            let product = products[indexPath.row]
            cell.setProductName(productName: product.name)
            cell.setProductImage(image: "imageproduct")
            cell.setProductPrice(price: product.price)
            return cell
        }
    }
}

