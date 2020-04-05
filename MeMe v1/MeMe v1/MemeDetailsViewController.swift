//
//  MemeDetailsViewController.swift
//  MeMe v1
//
//  Created by Gokhan Namal on 5.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var meme: MemeViewController.Meme?
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme?.memedImage
    }
}
