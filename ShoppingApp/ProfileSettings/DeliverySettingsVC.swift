//
//  DeliverySettingsVC.swift
//  ShoppingApp
//
//  Created by Agata Menes on 05/12/2022.
//

import UIKit
import MaterialComponents
import Firebase

class DeliverySettingsVC: UIViewController, Alertable {
    @IBOutlet weak var fullNameField: MDCOutlinedTextField!
    @IBOutlet weak var address1Field: MDCOutlinedTextField!
    @IBOutlet weak var address2Field: MDCOutlinedTextField!
    @IBOutlet weak var cityField: MDCOutlinedTextField!
    @IBOutlet weak var zipCodeField: MDCOutlinedTextField!
    @IBOutlet weak var countryField: MDCOutlinedTextField!
    @IBOutlet weak var stateField: MDCOutlinedTextField!
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFields()
        getDeliveryAddress()
    }

    func setUpFields() {
        fullNameField.label.text = "Full name"
        address1Field.label.text = "Address 1"
        address2Field.label.text = "Address 2"
        zipCodeField.label.text = "Zip Code"
        cityField.label.text = "City"
        stateField.label.text = "State"
        countryField.label.text = "Country"
        
    }

    @IBAction func saveAddress(_ sender: Any) {
        guard let address1 = address1Field.text,
              let address2 = address2Field.text,
              let zipCode = zipCodeField.text,
              let city = cityField.text,
              let state = stateField.text,
              let country = countryField.text,
              let name = fullNameField.text else {
            print("didnt save address")
            return
              }
        
        let address = [
            "address1":  address1,
            "address2": address2,
            "zipCode": zipCode,
            "city": city,
            "state": state,
            "country": country,
            "name": name
        ]
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
        self.database.child("users").child(safeEmail).child("address").setValue(address, withCompletionBlock: { [weak self] error, _ in
            guard error != nil else { return }
            print("Saved address")
        })
       // navigationController?.popViewController(animated: true)
    }
    
    func getDeliveryAddress() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
        database.child("users").child(safeEmail).child("address").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if let data = snapshot.value as? [String: String] {
                guard let name = data["name"],
                      let address1 = data["address1"],
                      let address2 = data["address2"],
                      let city = data["city"],
                      let state = data["state"],
                      let country = data["country"],
                      let zipCode = data["zipCode"] else {
                    print("failed to fetch address data")
                    return
                }
                DispatchQueue.main.async {
                    self?.fullNameField.text = name
                    self?.address1Field.text = address1
                    self?.address2Field.text = address2
                    self?.cityField.text = city
                    self?.stateField.text = state
                    self?.countryField.text = country
                    self?.zipCodeField.text = zipCode
                }
                
            }
        })
    }
    
}
