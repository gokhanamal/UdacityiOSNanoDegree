//
//  ShowLocationViewController.swift
//  On The Map
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit
import MapKit

class ShowLocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    var mapItem:  MKMapItem?
    var mediaURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let mapItem = mapItem {
            let annotion = MKPointAnnotation()
            annotion.title = mapItem.name
            annotion.coordinate = mapItem.placemark.coordinate
            mapView.addAnnotation(annotion)
            let region = MKCoordinateRegion( center: mapItem.placemark.coordinate, latitudinalMeters: CLLocationDistance(exactly: 1000)!, longitudinalMeters: CLLocationDistance(exactly: 1000)!)
            mapView.setRegion(region, animated: true)
        }
    }
    @IBAction func onPressFinish(_ sender: Any) {
        if let mapItem = mapItem, let mediaURL  = mediaURL {
            let coordinate = mapItem.placemark.coordinate
            OTMClient.addNewLocation(mapString: mapItem.name ?? "", mediaURL: mediaURL, latitude: coordinate.latitude, longitude: coordinate.longitude) { success, error in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
