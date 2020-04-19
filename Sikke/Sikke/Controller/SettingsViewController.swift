//
//  SettingsScreen.swift
//  Sikke
//
//  Created by Gokhan Namal on 19.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    let buttons = [["Sources","Feedback & Support", "Rate in the App Store"],["Make contribution on GitHub",]]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell")
        cell?.textLabel?.text = buttons[indexPath.section][indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "The reference rates are usually updated around 16:00 CET on every working day, except on TARGET closing days. They are based on a regular daily concertation procedure between central banks across Europe, which normally takes place at 14:15 CET."
        }
        return "Sikke app is an open source project. You can contribute and help to improve some features."
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let url = URL(string: "https://github.com/gokhanamal/UdacityiOSNanoDegree/Sikke")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
