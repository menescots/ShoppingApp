//
//  ProfileViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 28/10/2022.
//

import UIKit
import FacebookLogin
import FirebaseAuth
import FirebaseCore
class ProfileViewController: UIViewController {
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNameLabel()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.logOutButton.isHidden = false
            strongSelf.setNameLabel()
        })
    }
    
    func setNameLabel() {
        guard let loggedUser = UserDefaults.standard.value(forKey: "email") as? String else {
            logOutButton.isHidden = true
            return
        }
        userNameLabel.text = "Hello \(loggedUser)"
    }
    @IBAction func logOutTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Do you want to log out?",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Log out",
                                            style: .destructive,
                                            handler: { [weak self] _ in
            
            guard let strongSelf = self else { return }
            
            FBSDKLoginKit.LoginManager().logOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "name")
                strongSelf.logOutButton.isHidden = true
                strongSelf.userNameLabel.text = "Sign In on Sign Up"
            } catch {
                print("Failed to log out.")
            }
        }))
        present(actionSheet, animated: true)
    }
    
    
    @IBAction func FBLoginButtonTapped(_ sender: Any) {
       
    }
    
    
}

