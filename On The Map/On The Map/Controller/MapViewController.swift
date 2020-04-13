//
//  MapViewController.swift
//  On The Map
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        mapView.delegate = self
        addNavbarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // if we use viewWillAppear instead of viewDidLoad to get locations, we don't have to listen changes for OTMModel.locations.
        getAllLocations()
    }
    
    @objc func onPressRefresh() {
        getAllLocations()
    }
    
    func getAllLocations() {
        OTMClient.getUserLocation() { users, error in
            if let error = error {
                self.showErrorAlert(title: "Request failed!", message: error.localizedDescription)
            } else {
                OTMModel.users = users
                let annotions = users.map(self.userMapToAnnotation)
                self.mapView.addAnnotations(annotions)
            }
        }
    }
    
    func userMapToAnnotation(user: User) -> MKPointAnnotation {
        let annotion = MKPointAnnotation()
        annotion.title = "\(user.firstName) \(user.lastName)"
        annotion.subtitle = user.mediaURL
        annotion.coordinate = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
        return annotion
    }
    
    func addNavbarButton() {
        let addButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(onPressAdd))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(onPressRefresh))
        navigationItem.rightBarButtonItems = [addButton,refreshButton]
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(onPressLogout))
        navigationItem.leftBarButtonItem = logoutButton
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let urlString = view.annotation?.subtitle, let url = URL(string: urlString ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "user")
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return view
    }
}
