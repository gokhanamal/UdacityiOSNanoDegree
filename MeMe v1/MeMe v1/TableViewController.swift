//
//  TableViewController.swift
//  MeMe v1
//
//  Created by Gokhan Namal on 4.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var memes = [MemeViewController.Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    
        navigationItem.rightBarButtonItem = add
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: "createMeme", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeRow", for: indexPath) as? TableViewCell
        
        if let cell = cell {
            let meme = memes[indexPath.row]
            cell.memeView?.image = meme.memedImage
            cell.titleLabel?.text = "\(meme.topText) \(meme.bottomText)"
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "MemeDetails") as! MemeDetailsViewController
        VC.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
