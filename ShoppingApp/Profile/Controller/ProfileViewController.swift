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
import FirebaseDatabase

class ProfileViewController: UIViewController {
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    private var loginObserver: NSObjectProtocol?
    private let database = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNameLabel()

        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: nil, using: { [weak self] _ in
            print("in observer")
            self?.logOutButton.isHidden = false
            self?.setNameLabel()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfLogged()
    }

    func checkIfLogged(){
        FirebaseAuth.Auth.auth().addStateDidChangeListener { auth ,user in
            if user == nil {
                guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginVC") as? LoginViewController else {
                    return
                }
               // self.definesPresentationContext = true
                //self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.present(UINavigationController(rootViewController: vc), animated: false)
            }
        }
    }
    func setNameLabel() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.shared.safeEmail(email: email)
        
        database.child("users").child(safeEmail).observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if let data = snapshot.value as? [String: Any] {
                
                guard let name = data["name"],
                      let surname = data["surname"] else {
                    print("Couldnt fetch data")
                    return
                }
                self?.userNameLabel.text = "Hello, \(name) \(surname)"
                
            }
        })
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
                
                DispatchQueue.main.async {
                    strongSelf.logOutButton.isHidden = true
                    strongSelf.userNameLabel.text = "Sign In on Sign Up"
                }
            } catch {
                print("Failed to log out.")
            }
        }))
        present(actionSheet, animated: true)
    }
    
    
    @IBAction func FBLoginButtonTapped(_ sender: Any) {
       
    }
    override func present(_ viewControllerToPresent: UIViewController,
                            animated flag: Bool,
                            completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        super.present(viewControllerToPresent, animated: flag, completion: completion)
      }
    
}

