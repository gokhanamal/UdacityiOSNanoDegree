//
//  LocationListViewController.swift
//  On The Map
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit
import MapKit

class LocationListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavbarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // if we use viewWillAppear instead of viewDidLoad to get locations, we don't have to listen changes for OTMModel.locations.
        getAllLocations()
    }
    
    @objc func onPressRefresh() {
        getAllLocations()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMModel.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
        let user = OTMModel.users[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.detailTextLabel?.text = user.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = OTMModel.users[indexPath.row]
        if let url = URL(string: user.mediaURL){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func addNavbarButtons() {
        let addButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(onPressAdd))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(onPressRefresh))
        navigationItem.rightBarButtonItems = [addButton,refreshButton]
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(onPressLogout))
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    func getAllLocations() {
        OTMClient.getUserLocation() { users, error in
            if let error = error {
                self.showErrorAlert(title: "Request failed!", message: error.localizedDescription)
            } else {
                OTMModel.users = users
                self.tableView.reloadData()
            }
           
        }
    }
}
