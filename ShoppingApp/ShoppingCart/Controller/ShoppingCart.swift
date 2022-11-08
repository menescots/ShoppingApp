//
//  ShoppingCartViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 07/11/2022.
//

import UIKit

class ShoppingCart: UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    var cartProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
    }

}

extension ShoppingCart: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
        
        let product = cartProducts[indexPath.row]
        
        cell.indexPath = indexPath
        cell.setProductName(productName: product.name)
        cell.setProductImage(image: "imageproduct")
        cell.wishlistButton.titleLabel?.text = ""
        cell.setProductPrice(price: product.price)
        
        return cell
    }
    
    
}
