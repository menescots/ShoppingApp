//
//  ProductDetailController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 12/12/2022.
//

import UIKit

class ProductDetailController: UIViewController {
    
    @IBOutlet weak var productNameLabel: UILabel!
    var product: Product?
    
    @IBOutlet weak var productDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let name = product?.name,
              let desc = product?.content else {
            return
        }
        productNameLabel.text = name
        productDescription.text = desc
        print(productDescription.text)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
