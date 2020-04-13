//
//  ViewController.swift
//  On The Map
//
//  Created by Gokhan Namal on 10.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onPressLogin(_ sender: Any) {
        guard
            let username = emailTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {return}
        
        setLoadig(true)
        OTMClient.createSession(username: username, password: password) { success, error in
            self.setLoadig(false)
            if success {
                self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
            } else {
                self.loginAlert(message: error?.localizedDescription ?? "")
            }
        }
    }
    @IBAction func onPressSignUp(_ sender: Any) {
        UIApplication.shared.open(OTMClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func setLoadig(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        passwordTextField.isEnabled = !isLoading
        emailTextField.isEnabled = !isLoading
        loginButton.isEnabled = !isLoading
    }
    
    func loginAlert(message: String) {
        showErrorAlert(title: "Login Error!", message: message)
    }
}

