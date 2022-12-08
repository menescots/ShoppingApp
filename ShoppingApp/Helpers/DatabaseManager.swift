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
    
    func safeEmail(email: String) -> String {
        let splitArray = email.split(separator: "@")
           return String(splitArray[0])
    }
}
