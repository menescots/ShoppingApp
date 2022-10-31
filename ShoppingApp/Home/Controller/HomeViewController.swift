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

class HomeViewController: UIViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var UIStackView: UIStackView!
    var container: NSPersistentContainer!
    var categories = [Category]()
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionLayout()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        if AccessToken.isCurrentAccessTokenActive {
            print("your session is active")
        }
        container = NSPersistentContainer(name: "ShoppingApp")
        performSelector(inBackground: #selector(fetchProducts), with: nil)
        performSelector(inBackground: #selector(fetchCategory), with: nil)
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
            self.container.viewContext.automaticallyMergesChangesFromParent = true
        }
        loadProductSavedData()
        loadCategoriesSavedData()
    }
    
    @objc func fetchCategory(){
        do {
            if let bundlePath = Bundle.main.path(forResource: "Category",
                                                 ofType: "json"),
               let jsonData = try? String(contentsOfFile: bundlePath) {
                let jsonCategories = JSON(parseJSON: jsonData)
                // read the commits back out
                let jsonCategoriesArray = jsonCategories.arrayValue
                
                DispatchQueue.main.async { [unowned self] in
                    for jsonCategory in jsonCategoriesArray {
                        let category = Category(context: self.container.viewContext)
                        self.configureCategory(category: category, usingJSON: jsonCategory)
                        categoryCollectionView.reloadData()
                    }
                    self.saveContext()
                    self.loadCategoriesSavedData()
                }
            }
        } catch {
            print(error)
        }
    }
    
    @objc func fetchProducts() {
        do {
            if let bundlePath = Bundle.main.path(forResource: "Products",
                                                 ofType: "json"),
               let jsonData = try? String(contentsOfFile: bundlePath) {
                let jsonProducts = JSON(parseJSON: jsonData)
                
                // read the commits back out
                let jsonProductsArray = jsonProducts.arrayValue
                
                DispatchQueue.main.async { [unowned self] in
                    for jsonProduct in jsonProductsArray {
                        let product = Product(context: self.container.viewContext)
                        self.configureProducts(product: product, usingJSON: jsonProduct)
                        productsCollectionView.reloadData()
                    }
                    
                    self.saveContext()
                    self.loadProductSavedData()
                }
            }
        } catch {
            print(error)
        }
    }
    func configureCategory(category: Category, usingJSON json: JSON) {
        category.name = json["name"].stringValue
        category.content = json["content"].stringValue
    }
    func configureProducts(product: Product, usingJSON json: JSON) {
        product.name = json["name"].stringValue
        product.content = json["content"].stringValue
        product.price = json["price"].int32Value
        product.rate = json["price"].floatValue
        product.review = json["review"].int16Value
        product.imageUrl = json["imageUrl"].stringValue
        product.id = json["id"].int32Value
        
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    @IBAction func addToWishlistButtonTapped(_ sender: Any) {
        
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
    
    func loadProductSavedData() {
        let request = Product.fetchRequest()
        do {
            products = try container.viewContext.fetch(request)
            print("reloaded data")
            productsCollectionView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func loadCategoriesSavedData() {
        let request = Category.fetchRequest()
        do {
            categories = try container.viewContext.fetch(request)
            categoryCollectionView.reloadData()
        } catch {
            print("Fetch failed")
        }
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
            cell.setLabelTitle(title: category.name ?? "empty" )
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
            
            let product = products[indexPath.row]
            
            cell.setProductName(productName: product.name!)
            cell.setProductImage(image: "imageproduct")
            cell.setProductPrice(price: product.price)
            return cell
        }
    }
}
