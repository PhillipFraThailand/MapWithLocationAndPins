//
//  ViewController.swift
//  MapMandatory
//
//  Created by Phillip Eismark on 01/03/2019.
//  Copyright © 2019 Phillip Eismark. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("new location \(String(describing: locations.first))")
        if let coord = locations.first?.coordinate {
            print("Current coordinate \(coord)")
            let region = MKCoordinateRegion(center: coord, latitudinalMeters: 400, longitudinalMeters: 400)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        default:
            mapView.showsUserLocation = false
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func longPressPressed(_ sender: UILongPressGestureRecognizer) {
        print("Uden for long press")
        if sender.state == UILongPressGestureRecognizer.State.ended {
            print("Long press registered")
            
            let gpsCoord = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            print("Long press at: \(gpsCoord)")
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = gpsCoord
            mapView.addAnnotation(annotation)
            
            let alerter = UIAlertController(title: "Do you want to name your pin?", message: "You should name your pin to help you remember what it points at", preferredStyle: UIAlertController.Style.alert)
            
            alerter.addTextField(configurationHandler: { textField in textField.placeholder = "Pin name here" })
            alerter.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                if let input = alerter.textFields?.first?.text {
                    annotation.title = input
                }
            }))
             alerter.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alerter, animated: true)
            
        }
    }
}
