//
//  LoginViewController.swift
//  ShoppingApp
//
//  Created by Agata Menes on 25/10/2022.
//

import UIKit
import FacebookLogin
class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.layer.contents = #imageLiteral(resourceName: "background.jpeg").cgImage
        
//        let loginButton = FBLoginButton()
//        loginButton.center = view.center
//        view.addSubview(loginButton)
        
        if let token = AccessToken.current,
                !token.isExpired {
                // User is logged in, do work such as go to next view controller.
            }
    }


}
