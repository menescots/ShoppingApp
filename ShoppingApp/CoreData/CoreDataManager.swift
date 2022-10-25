//
//  CoreDataManager.swift
//  ShoppingApp
//
//  Created by Agata Menes on 21/10/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "ShoppingApp")
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
        
    }
}
