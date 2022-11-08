//
//  ShoppingApp+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Agata Menes on 08/11/2022.
//
//

import Foundation
import CoreData


extension ShoppingApp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingApp> {
        return NSFetchRequest<ShoppingApp>(entityName: "ShoppingApp")
    }

    @NSManaged public var name: String
    @NSManaged public var productId: Int32
    @NSManaged public var price: Int32
    @NSManaged public var categoryId: Int32
    @NSManaged public var imageUrl: String?

}

extension ShoppingApp : Identifiable {

}
