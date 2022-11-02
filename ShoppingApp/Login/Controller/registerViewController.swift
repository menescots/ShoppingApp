//
//  registerViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 31/10/2022.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
class registerViewController: UIViewController {

    @IBOutlet weak var emailField: MDCOutlinedTextField!
    
    @IBOutlet weak var confirmPassword: MDCOutlinedTextField!
    @IBOutlet weak var passwordField: MDCOutlinedTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.label.text = "Password"
        emailField.label.text = "Email"
        confirmPassword.label.text = "Confirm password"
       
    }
    @IBAction func signUpTapped(_ sender: Any) {
    }
    
}
