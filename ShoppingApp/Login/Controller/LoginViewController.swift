//
//  LoginViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 25/10/2022.
//

import UIKit
import FacebookLogin
import FirebaseAuth

import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LoginViewController: UIViewController, UITextViewDelegate, Alertable {
    private var loginObserver: NSObjectProtocol?
    @IBOutlet weak var passwordField: MDCOutlinedTextField!
    @IBOutlet weak var emailField: MDCOutlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.label.text = "Password"
        emailField.label.text = "Email"
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            self.showAlert(title: "Wrong email or password", message: nil)
            return
        }
        
        // firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            
            guard error == nil else {
                self?.showAlert(title: "Failed to sign in :(", message: "Check your credentials and try again.")
                return
            }
            UserDefaults.standard.setValue(email, forKey: "email")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
            self?.navigationController?.dismiss(animated: true)
        })
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registerVC") as? registerViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
