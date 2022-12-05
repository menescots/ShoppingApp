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
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var optionTableView: UITableView!
    var settingOptions = ["Delivery address", "Settings", "Orders"]

    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNameLabel()
        optionTableView.dataSource = self
        optionTableView.delegate = self
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.logOutButton.isHidden = false
            strongSelf.setNameLabel()
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
        guard let loggedUser = UserDefaults.standard.value(forKey: "name") as? String else {
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
    override func present(_ viewControllerToPresent: UIViewController,
                            animated flag: Bool,
                            completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        super.present(viewControllerToPresent, animated: flag, completion: completion)
      }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = settingOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
