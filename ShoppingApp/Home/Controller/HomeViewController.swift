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
                        categoryCollectionView.reloadData()
                    }

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
                        productsCollectionView.reloadData()
                    }
                }
            }
        } catch {
            print(error)
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
