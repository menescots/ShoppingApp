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

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    var filteredProducts = [Product]()
    var isFiltering = false
    @IBOutlet weak var filterTextField: UITextField!
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
            productsCollectionView.delegate = self
            filterTextField.delegate = self
            productsCollectionView.dataSource = self
            self.setUpCollectionLayout()
            DispatchQueue.global(qos: .background).async {
                self.listenForProducts()
                DispatchQueue.main.async {
                    self.productsCollectionView.reloadData()
                }
            }
            
            checkInternetState()
            reloadButton.addTarget(self, action: #selector(listenForProducts), for: .touchUpInside)
            self.view.addSubview(reloadButton)
            self.view.addSubview(noInternetInfo)
            filterTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @objc func textFieldDidChange() {
        guard let text = filterTextField.text?.lowercased() else { return }
        if text.count > 0 {
            isFiltering = true
            filteredProducts = products.filter {
                $0.name.lowercased().contains(text)
            }
        } else {
            isFiltering = false
            filteredProducts = products
        }
        self.productsCollectionView.reloadData()
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
                        
                        self.products.append(Product(id: id, name: name, price: price, categoryId: categoryId, content: content, imageUrl: nil, amount: nil))
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
            let wishlistProducts = [
                "ID": product.id
            ]
            
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
            let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
            self.database.child("users").child(safeEmail).child("Wishlist").child("\(product.id)").setValue(wishlistProducts, withCompletionBlock: { [weak self] error,_  in
                guard error != nil else { return }
                print("added to wish")
            })
        }

        @IBAction func addToCartButtonTapped(_ sender: Any) {
            guard let indexPath = productsCollectionView?.indexPath(for: (((sender as AnyObject).superview??.superview) as! ProductsCollectionViewCell)) else { return }
            
            let product = products[indexPath.row]
            let cartProduct = [
                "amount": 1
            ]
            
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
            let safeEmail = DatabaseManager.shared.safeEmail(email: email)
            
            isInCart(id: product.id, completion: { exists in
                if !exists {
                    self.database.child("users").child(safeEmail).child("Cart").child("\(product.id)").setValue(cartProduct, withCompletionBlock: { [weak self] error,_  in
                        guard error == nil else { return }
                    })
                } else {
                    self.database.child("users").child(safeEmail).child("Cart").child("\(product.id)").removeValue(completionBlock: { error,_  in
                        guard error == nil else { return }
                        let info = ["id" : product.id]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: info)
                    })
                }
            })
        }
    
    func isInCart(id: Int, completion: @escaping (Bool) -> Void) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
        self.database.child("users").child(safeEmail).child("Cart").child(String(id)).observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                completion(false)
            } else {
                completion(true)
            }
        })
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
            return isFiltering == true ? filteredProducts.count : products.count
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductsCollectionViewCell
            
            let product = isFiltering == true ? filteredProducts[indexPath.row] : products[indexPath.row]

            cell.setProductName(productName: product.name)
            cell.setProductImage(image: "imageproduct")
            cell.setProductPrice(price: product.price)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let product = products[indexPath.row]
             let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "productDetail") as! ProductDetailController
            vc.product = product
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
