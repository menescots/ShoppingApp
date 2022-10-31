//
//  LoginViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 25/10/2022.
//

import UIKit
import FacebookLogin
class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
setUpFields()

    }

    @IBAction func signInTapped(_ sender: Any) {
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
    }
    
    func setUpFields() {
        emailField.layer.cornerRadius = 5
        emailField.layer.borderWidth = 1.0
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.setLeftPaddingPoints(5)
        passwordField.layer.cornerRadius = 5
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.setLeftPaddingPoints(5)
        
    }
}
