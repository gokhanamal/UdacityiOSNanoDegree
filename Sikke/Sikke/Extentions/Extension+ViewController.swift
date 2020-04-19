//
//  Extension+ViewController.swift
//  Sikke
//
//  Created by Gokhan Namal on 19.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String?, actions: [UIAlertAction]?) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                vc.addAction(action)
            }
        } else {
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            vc.addAction(action)
        }
        self.present(vc, animated: true, completion: nil)
      }
}
