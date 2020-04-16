//
//  PhotoCell.swift
//  Virtual Tourist
//
//  Created by Gokhan Namal on 14.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override var isSelected: Bool {
        didSet {
            self.imageView.alpha = isSelected ? 0.3 : 1.0
        }
    }
}
