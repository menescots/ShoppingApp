//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 24/10/2022.
//

import UIKit
import FacebookLogin
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var UIStackView: UIStackView!
    var categoryDataSource = ["Man's", "Woman's","Kids'", "Winter", "Summer", "Spring", "Cats"]
    var prices = ["13", "43","22", "11", "50", "40", "04"]
    var productName = ["hoodie", "thsirt","trousers'", "dress", "dress", "tshirt", "Cats"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStackView()
        setUpCollectionLayout()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self

    }

    @IBAction func addToWishlistButtonTapped(_ sender: Any) {
        
    }
    @IBAction func addToCartButtonTapped(_ sender: Any) {
    }
    
    func setUpStackView(){
        UIStackView.insertCustomizedViewIntoStack(background: .white, cornerRadius: 20, shadowColor: UIColor(named: "shadowColor")!.cgColor, shadowOpacity: 1, shadowRadius: 4.0)
        UIStackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 20)
        UIStackView.isLayoutMarginsRelativeArrangement = true
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
            return categoryDataSource.count
        } else {
            return productName.count
        }
   
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
            cell.setLabelTitle(title: categoryDataSource[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
            cell.setProductName(productName: productName[indexPath.row])
            cell.setProductImage(image: "imageproduct")
            cell.setProductPrice(price: prices[indexPath.row])
            return cell
        }
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.productsCollectionView {
//            print("in layout")
//            return CGSize(width: UIScreen.main.bounds.width/2, height: 200)
//        } else {
//            return CGSize(width: 133, height: 38)
//        }
//    }
}
