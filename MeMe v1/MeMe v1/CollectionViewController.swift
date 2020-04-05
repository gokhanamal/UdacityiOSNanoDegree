//
//  CollectionCollectionViewController.swift
//  MeMe v1
//
//  Created by Gokhan Namal on 5.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes = [MemeViewController.Meme]()
    private let reuseIdentifier = "memeCollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2*space)) / 3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        memes = appDelegate.memes
        print(memes)
        self.collectionView.reloadData()
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: "createMeme", sender: self)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell
        cell?.imageView.image = memes[indexPath.row].memedImage
        return cell ?? UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "MemeDetails") as! MemeDetailsViewController
        VC.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
