//
//  WishlistViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 03/11/2022.
//

import UIKit

class WishlistViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    
    var products = ["hllo"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    


}

extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "wishlistCell") as! WishlistCustomCell
        return cell
    }
    
    
}
