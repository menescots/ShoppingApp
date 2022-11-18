//
//  CategoryProductsViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 15/11/2022.
//

import UIKit
import FirebaseDatabase

class CategoryProductsViewController: UIViewController {
    
    private let database = Database.database().reference()
    @IBOutlet weak var productsCollectionView: UICollectionView!
    var products = [Product]()
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionLayout()
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        title = category?.name
        DispatchQueue.global(qos: .background).async {
            self.listenForProducts()
            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
            }
        }
    }
    func listenForProducts() {
        database.child("Products").observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [[String: Any]] {
                for datum in data {
                    guard let name = datum["name"] as? String,
                          let price = datum["price"] as? Int,
                          let id = datum["id"] as? Int,
                          let categoryId = datum["categoryId"] as? Int,
                          let content = datum["content"] as? String else {
                        print("returned")
                        return
                    }
                    if categoryId == self.category?.id {
                        self.products.append(Product(id: id, name: name, price: price, categoryId: categoryId, content: content, imageUrl: nil))
                        self.productsCollectionView.reloadData()
                        print(self.products)
                    }
                }
            }
        })
    }
}
extension CategoryProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(products.count)
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
