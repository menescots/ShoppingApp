//
//  ShoppingCart+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Agata Menes on 09/11/2022.
//
//

import Foundation
import CoreData


extension ShoppingCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingCart> {
        return NSFetchRequest<ShoppingCart>(entityName: "ShoppingCart")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String
    @NSManaged public var price: Int32
    @NSManaged public var productId: Int32
    @NSManaged public var amount: Int32
}

extension ShoppingCart : Identifiable {

}
