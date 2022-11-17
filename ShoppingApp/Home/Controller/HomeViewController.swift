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
    @IBOutlet weak var UIStackView: UIStackView!
    private let database = Database.database().reference()
    var container: NSPersistentContainer!
    var products = [Product]()
    var wishlistProducts = [Wishlist]()
    var cartProducts = [ShoppingCart]()
    
    var reloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.isHidden = true
        return button
    }()
    var noInternetInfo: UILabel = {
        let label = UILabel()
        label.text = "Fetching products..."
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionLayout()
       productsCollectionView.delegate = self
       productsCollectionView.dataSource = self
        DispatchQueue.main.async {
            self.listenForProducts()
        }
    
        checkInternetState()
        reloadButton.addTarget(self, action: #selector(listenForProducts), for: .touchUpInside)
        self.view.addSubview(reloadButton)
        self.view.addSubview(noInternetInfo)
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
            } else {
                self.reloadButton.isHidden = false
            }
        })
    }
    
    func checkInternetState() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
          if snapshot.value as? Bool ?? false {
              self.reloadButton.isHidden = true
              self.noInternetInfo.isHidden = true
          } else {
              self.reloadButton.isHidden = false
              self.noInternetInfo.isHidden = false
          }
        })
    }
    @IBAction func addToWishlistButtonTapped(_ sender: Any) {
        guard let indexPath = productsCollectionView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! ProductsCollectionViewCell)) else { return }
        
        let product = products[indexPath.row]
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        
        let wishlistedProduct = Wishlist(context: managedContext)
        
        wishlistedProduct.setValue(product.name, forKey: #keyPath(Wishlist.name))
        wishlistedProduct.setValue(product.price, forKey: #keyPath(Wishlist.price))
        wishlistedProduct.setValue(product.id, forKey: #keyPath(Wishlist.productId))
        wishlistedProduct.setValue(product.imageUrl, forKey: #keyPath(Wishlist.image))
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
    }
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        guard let indexPath = productsCollectionView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! ProductsCollectionViewCell)) else { return }
        
        let product = products[indexPath.row]
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let cartProduct = ShoppingCart(context: managedContext)
        cartProduct.setValue(product.name, forKey: #keyPath(ShoppingCart.name))
        cartProduct.setValue(product.price, forKey: #keyPath(ShoppingCart.price))
        cartProduct.setValue(product.id, forKey: #keyPath(ShoppingCart.productId))
        cartProduct.setValue(product.imageUrl, forKey: #keyPath(ShoppingCart.image))
        self.cartProducts.insert(cartProduct, at: 0)
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = 44
        reloadButton.frame = CGRect(x: (Int(view.frame.width)-size)/2,
                                
                                    y: 50,
                                    width: size,
                                    height: size)
        reloadButton.center.x = self.view.center.x
        reloadButton.center.y = self.view.center.y
        noInternetInfo.frame = CGRect(x: (Int(view.frame.width)-size)/2,
                                      y: Int(reloadButton.bottom)+10,
                                      width: Int(view.frame.width),
                                      height: size)
        noInternetInfo.center.x = self.view.center.x
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return products.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
            
            let product = products[indexPath.row]
            cell.setProductName(productName: product.name)
            cell.setProductImage(image: "imageproduct")
            cell.setProductPrice(price: product.price)
            return cell
    }
}

