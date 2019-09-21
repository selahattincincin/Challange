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

    
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthoriization()
        }else {
            
        }
    }
    private func sendLocation() {
        guard let longitude: Double = locationManager.location?.coordinate.longitude,
            let latitude: Double = locationManager.location?.coordinate.latitude else { return }
        let location = Location(longitude: longitude, latitude: latitude)
        locationService.sendLocation(location: location) {
            print("bir şey oldu ama nee oldu daha anlamadık.")
        }
    }
    
    
    func setupPressRecogniser() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPressRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecogniser)
        
        mapView.mapType = MKMapType.standard
    }
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "latitude:" + String(format: "%.02f",annotation.coordinate.latitude) + "& longitude:" + String(format: "%.02f",annotation.coordinate.longitude)
        mapView.addAnnotation(annotation)
        
    }
    
    
    var selectedAnnotation: MKPointAnnotation?
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let latValStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.latitude)!))
        let lonvalStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.longitude)!))
        
        print("latitude: \(latValStr) & longitude: \(lonvalStr)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setupPressRecogniser()
        
    }
    
    let locationService = LocationService()
    
    let locationManager = CLLocationManager()
    let regionInMeters:Double = 10000
    
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func tappedShowLocation(_ sender: UIButton) {
        let alert = UIAlertController(title: "Konumum", message: "", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Canceled")
        }
        let actionSend = UIAlertAction(title: "Send", style: .default) { (action) in
            print("umarım gönderdi")
            self.sendLocation()
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
