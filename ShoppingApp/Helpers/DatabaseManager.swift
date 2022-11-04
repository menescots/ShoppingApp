//
//  DatabaseManager.swift
//  ShoppingApp
//
//  Created by Agata Menes on 04/11/2022.
//

import Foundation
import FirebaseDatabase
final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}
