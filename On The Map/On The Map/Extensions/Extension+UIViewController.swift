//
//  Extention+ViewController.swift
//  On The Map
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

extension UIViewController{
    @objc func onPressAdd() {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
    
    @objc func onPressLogout() {
        OTMClient.logout() { success, error in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showErrorAlert(title: "Logout Faild!", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
