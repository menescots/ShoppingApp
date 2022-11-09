//
//  Wishlist+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Agata Menes on 09/11/2022.
//
//

import Foundation
import CoreData


extension Wishlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wishlist> {
        return NSFetchRequest<Wishlist>(entityName: "Wishlist")
    }

    @NSManaged public var productId: Int32
    @NSManaged public var name: String
    @NSManaged public var price: Int32
    @NSManaged public var image: String?

}

extension Wishlist : Identifiable {

}
