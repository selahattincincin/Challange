//
//  MapViewController.swift
//  Challange
//
//  Created by Selahattin Cincin on 21.09.2019.
//  Copyright © 2019 Selahattin Cincin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let regionInMeters:Double = 10000

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()

        
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthoriization()
        }else {
            
        }
    }
    func checkLocationAuthoriization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //Show alert how to turn on permission
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //show alert letting them whats going on
            break
        case .authorizedAlways:
            break
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func tappedShowLocation(_ sender: UIButton) {
        let alert = UIAlertController(title: "Konumum", message: "", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("action1")
        }
        let actionSend = UIAlertAction(title: "Send", style: .default) { (action) in
            print("action2")
        }
        alert.addAction(actionCancel)
        alert.addAction(actionSend)
        present(alert, animated: true, completion: nil)
    }
    
}

extension MapViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center , latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthoriization()
    }
    
}
