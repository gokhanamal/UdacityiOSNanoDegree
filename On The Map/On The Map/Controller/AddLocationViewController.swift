//
//  FindLocationViewController.swift
//  On The Map
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var locaitonTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelButton = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(onPressCancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        // Do any additional setup after loading the view.
    }
    
    @objc func onPressCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPressFindLocation(_ sender: Any) {

        if let query = locaitonTextField.text, let url = urlTextField.text, !url.isEmpty {
            setLoading(true)
            findLocation(query: query)
        } else {
            locationErrorAlert(message: "Please type an url and location.")
        }
    }
    
    func findLocation(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            self.setLoading(false)
            guard let item = response?.mapItems.first else {
                self.locationErrorAlert(message: "Could not find the place, please try another keyword.")
                return
            }
            self.performSegue(withIdentifier: "showLocation", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocation" {
            let VC = segue.destination as! ShowLocationViewController
            VC.mapItem = sender as? MKMapItem
            VC.mediaURL = urlTextField.text
        }
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            acitivityIndicator.startAnimating()
        } else {
            acitivityIndicator.stopAnimating()
        }
        findLocationButton.isEnabled = !isLoading
        locaitonTextField.isEnabled = !isLoading
        urlTextField.isEnabled = !isLoading
    }
    
    func locationErrorAlert(message: String) {
        showErrorAlert(title: "Add Location Error!", message: message)
    }
}
