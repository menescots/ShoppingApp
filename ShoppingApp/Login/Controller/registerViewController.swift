//
//  registerViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 31/10/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MaterialComponents.MaterialTextControls_OutlinedTextFields
class registerViewController: UIViewController, Alertable {

    @IBOutlet weak var surnameField: MDCOutlinedTextField!
    @IBOutlet weak var nameField: MDCOutlinedTextField!
    @IBOutlet weak var emailField: MDCOutlinedTextField!
    @IBOutlet weak var confirmPassword: MDCOutlinedTextField!
    @IBOutlet weak var passwordField: MDCOutlinedTextField!
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFields()
        
    }
    
    func setUpFields() {
        passwordField.label.text = "Password"
        emailField.label.text = "Email"
        confirmPassword.label.text = "Confirm password"
        nameField.label.text = "Name"
        surnameField.label.text = "Surname"
    }
    @IBAction func signUpTapped(_ sender: Any) {
        guard let email = emailField.text,
              !email.isEmpty,
              let name = nameField.text,
              !name.isEmpty,
              let surname = surnameField.text,
              !surname.isEmpty else {
            showAlert(title: "Fields can not be empty", message: nil)
            return
        }
        
        guard let password = passwordField.text,
              !password.isEmpty,
              password.count >= 7 else {
            showAlert(title: "Password must be at least 7 characters long.", message: nil)
            return
        }
        if checkPassword() {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
                guard authResult != nil, error == nil else {
                    self.showAlert(title: "Failed to create new user.", message: nil)
                    return
                }
                let post = [
                    "name":  name,
                    "surname": surname
                ]
                self.database.child("users").child("\(self.safeEmail(email: email))").setValue(post, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        self?.showAlert(title: "Failed to add new user.", message: nil)
                        return
                    }
                })
                
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(name, forKey: "name")
                UserDefaults.standard.set(surname, forKey: "surname")
               NotificationCenter.default.post(name: .didLogInNotification, object: nil)
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    func checkPassword() -> Bool{
        guard let password = passwordField.text,
              let confirmedPassword = confirmPassword.text else {
            return false
        }
        return password == confirmedPassword
    }
    
    func safeEmail(email: String) -> String {
        let splitArray = email.split(separator: "@")
           return String(splitArray[0])
    }
}
