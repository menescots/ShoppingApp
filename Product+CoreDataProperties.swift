//
//  Product+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Agata Menes on 27/10/2022.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Int32
    @NSManaged public var rate: Float
    @NSManaged public var review: Int16
    @NSManaged public var imageUrl: String?
    @NSManaged public var content: String?
    @NSManaged public var id: Int32
    @NSManaged public var category: Category?

}

extension Product : Identifiable {

}
