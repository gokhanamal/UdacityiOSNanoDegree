//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedAnnotion: MKAnnotation!
    
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupMapView()
        setupCoreData()
    }
    
    fileprivate func savePin(_ coordinate: CLLocationCoordinate2D) -> Pin {
        let pin = Pin(context: VTDataModel.dataController.viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        
        pins.append(pin)
        try? VTDataModel.dataController.viewContext.save()
        return pin
    }
    
    @objc func onLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        let annotation = createAnnotation(coordinate)
        mapView.addAnnotation(annotation)
    }
    
    fileprivate func setupCoreData() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? VTDataModel.dataController.viewContext.fetch(fetchRequest) {
            pins = result
            let annotations = result.map({ pin -> MKPointAnnotation in
                let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                return createAnnotation(coordinate)
            })
            mapView.addAnnotations(annotations)
        }
    }
    
    func createAnnotation(_ coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Open Photos"
        return annotation
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos" {
            let VC = segue.destination as! PhotosViewController
            let annotation = sender as? MKPointAnnotation
            let coordinate = annotation?.coordinate
            let selectedPin = pins.first(where: {$0.longitude == coordinate?.longitude && $0.latitude == coordinate?.latitude})
            
            if let selectedPin = selectedPin {
                VC.pin = selectedPin
            } else {
                guard let coordinate = coordinate else {return}
                VC.pin = savePin(coordinate)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "showPhotos", sender: view.annotation)
    }
    
    fileprivate func setupMapView() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.delegate = self
    }
}

