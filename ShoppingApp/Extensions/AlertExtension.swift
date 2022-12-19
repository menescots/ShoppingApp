//
//  AlertExtension.swift
//  ShoppingApp
//
//  Created by Agata Menes on 30/11/2022.
//

import Foundation
import UIKit

protocol Alertable { }
extension Alertable where Self: UIViewController {
    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithSettings(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let url = NSURL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.openURL(url as URL)
        }
        alertController.addAction(settingsAction)
        
        DispatchQueue.main.async {
            self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func addRemoveCartAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
    }
}
