//
//  ProfileViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 28/10/2022.
//

import UIKit
import FacebookLogin

class ProfileViewController: UIViewController {
    @IBOutlet weak var loginStackView: UIStackView!
    
    @IBOutlet weak var loginLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func loginButtonTaped(_ sender: Any) {
        FBSDKLoginKit.LoginManager().logOut()
    }
    @IBAction func facebookLoginButtonTapped(_ sender: Any) {
        // 1
            let loginManager = LoginManager()
            
            if let _ = AccessToken.current {
                print("logged in")
                loginManager.logOut()
                
            } else {
                loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
                    
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    guard let result = result, !result.isCancelled else {
                        print("User cancelled login")
                        return
                    }
                    
                    Profile.loadCurrentProfile { (profile, error) in
                        print(profile)
                    }
                }
            }
        }
    }

extension ProfileViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("user failder to log in with facebook")
            return
        }
                
    }
}
