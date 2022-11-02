//
//  LoginViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 25/10/2022.
//

import UIKit
import FacebookLogin
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LoginViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var passwordField: MDCOutlinedTextField!
    @IBOutlet weak var emailField: MDCOutlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.label.text = "Password"
        emailField.label.text = "Email"
        
    }

    @IBAction func signInTapped(_ sender: Any) {
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
    }
    

    @IBAction func closeTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}
