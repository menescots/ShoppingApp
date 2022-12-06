//
//  DeliverySettingsVC.swift
//  ShoppingApp
//
//  Created by Agata Menes on 05/12/2022.
//

import UIKit
import MaterialComponents

class DeliverySettingsVC: UIViewController {
    @IBOutlet weak var fullNameField: MDCOutlinedTextField!
    @IBOutlet weak var address1Field: MDCOutlinedTextField!
    @IBOutlet weak var address2Field: MDCOutlinedTextField!
    @IBOutlet weak var cityField: MDCOutlinedTextField!
    @IBOutlet weak var zipCodeField: MDCOutlinedTextField!
    @IBOutlet weak var stateField: MDCOutlinedTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFields()
        // Do any additional setup after loading the view.
    }
    
    func setUpFields() {
        fullNameField.label.text = "Full name"
        address1Field.label.text = "Address 1"
        address2Field.label.text = "Address 2"
        zipCodeField.label.text = "Zip Code"
        cityField.label.text = "City"
        stateField.label.text = "State"
    }

    @IBAction func saveAddress(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
