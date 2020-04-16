//
//  PhotosViewController.swift
//  Virtual Tourist
//
//  Created by Gokhan Namal on 14.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var toolbarButton: UIBarButtonItem!
    
    var pin: Pin!
    var photos = [Photo]()
    var isSavedBefore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupMapView()
        setupGridView()
        setupCoreData()
    }
    
    fileprivate func setupCoreData() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin = %@", pin)
        if let result = try? VTDataModel.dataController.viewContext.fetch(fetchRequest) {
            if result.isEmpty {
                 getPhotos(pageNumber: 1)
            } else {
                self.photos = result
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func getPhotos(pageNumber: Int) {
        toolbarButton.isEnabled = false
        VTClient.getPhotos(lat: pin.latitude, lon: pin.longitude, page: pageNumber) { photoURLs, error in
            for url in photoURLs {
                let photo = Photo(context: VTDataModel.dataController.viewContext)
                photo.imageURL = url
                photo.pin = self.pin
                self.photos.append(photo)
            }
            self.toolbarButton.isEnabled = true
            try? VTDataModel.dataController.viewContext.save()
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func setupMapView() {
        let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let annotation = createAnnotation(coordinate)
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = coordinate
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(UINib(nibName: PhotoCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
    }
    
    func createAnnotation(_ coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected Location"
        return annotation
    }
    
    fileprivate func removeSelectedIndex(_ selectedIndexPaths: [IndexPath]) {
        let indices = selectedIndexPaths.map({$0.row})
        
        let selectedPhotos = photos.enumerated().filter({indices.contains($0.offset)}).map({$0.element})
        for photo in selectedPhotos {
            VTDataModel.dataController.viewContext.delete(photo)
        }
        try? VTDataModel.dataController.viewContext.save()
        
        photos = photos.enumerated().filter({!indices.contains($0.offset)}).map({$0.element})
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: selectedIndexPaths)
        })
    }
    
    @IBAction func onPressToolbarButton(_ sender: Any) {
        let selectedIndexPaths = collectionView.indexPathsForSelectedItems!
        if selectedIndexPaths.count > 0 {
             removeSelectedIndex(selectedIndexPaths)
        } else {
            getNewColletion()
        }
       
        changeButtonState()
    }
    
    fileprivate func changeButtonState() {
        let selected = collectionView.indexPathsForSelectedItems?.count ?? 0
        if selected == 1 {
            toolbarButton.title = "Remove Selected Photos"
            toolbarButton.tintColor = .red
        }
        if selected == 0 {
            toolbarButton.title = "New Colletion"
            toolbarButton.tintColor = .systemBlue
        }
    }
    
    fileprivate func setupGridView() {
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2*space)) / 3.0
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3.0
        layout.minimumInteritemSpacing = 3.0
        layout.itemSize = CGSize(width: dimension, height: dimension)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func getNewColletion() {
        for photo in photos {
            VTDataModel.dataController.viewContext.delete(photo)
        }
        try? VTDataModel.dataController.viewContext.save()
        photos = []
        getPhotos(pageNumber: Int.random(in: 1 ... 10))
    }
    
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeButtonState()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        changeButtonState()
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        
        cell.activityIndicator.startAnimating()
        let url = URL(string: photos[indexPath.row].imageURL!)!
        
        VTClient.downloadImage(url: url) { image in
            cell.imageView.image = image
            cell.activityIndicator.stopAnimating()
        }
        
        return cell
    }
}
