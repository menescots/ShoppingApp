//
//  SearchCategoriesController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 14/11/2022.
//

import UIKit
import FirebaseDatabase
import CoreData
class SearchCategoriesController: UIViewController {
    var categories = [Category]()
    @IBOutlet weak var categoryTableView: UITableView!
    private let database = Database.database().reference()
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        DispatchQueue.global(qos: .background).async {
            self.listenForCategories()
            DispatchQueue.main.async {
                self.categoryTableView.reloadData()
            }
        }
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func listenForCategories() {
        database.child("Categories").observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [[String: Any]] {
                for datum in data {
                    guard let name = datum["name"] as? String,
                          let id = datum["id"] as? Int,
                          let content = datum["content"] as? String else { print("returned"); return }
                    
                    self.categories.append(Category(name: name, content: content, id: id))
                    self.categoryTableView.reloadData()
                }
            }
        })
    }
}
extension SearchCategoriesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell
        
        let category = categories[indexPath.row]
        cell.setCategoryImage(index: indexPath.row)
        cell.setCategoryName(name: category.name)
        cell.setCategoryContent(content: category.content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "categoryProduct") as? CategoryProductsViewController else {
            return
        }
        vc.category = categories[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
