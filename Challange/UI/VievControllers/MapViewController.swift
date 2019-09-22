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
    
    
    let locationService = LocationService()
    
    let locationManager = CLLocationManager()
    let regionInMeters:Double = 10000
    var selectedAnnotation: MKPointAnnotation?
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setupPressRecogniser()
        
    }
    
    
    @IBAction func tappedShowLocation(_ sender: UIButton) {
        let alert = UIAlertController(title: "Konumum", message: "\(String(describing: locationManager.location!.coordinate.latitude)) \(String(describing: locationManager.location!.coordinate.longitude))", preferredStyle: .alert)
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
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.delegate = self
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            reAskLocationPermission()
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        mapView.mapType = MKMapType.standard
    }
    
    
    @objc func handleTap(_ gestureReconizer: UITapGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        mapView.removeAnnotations(mapView.annotations)
        addPin(coordinate: coordinate)
        opendDetailViewController()
        
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let latValStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.latitude)!))
        let lonvalStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.longitude)!))
        
        print("latitude: \(latValStr) & longitude: \(lonvalStr)")
        
        
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
        checkLocationAuthorization()
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
        annotationView.image = UIImage(named: "ic_map_pin")
        annotationView.frame.size =  CGSize(width: 63, height: 81)
        return annotationView
    }
}


extension MapViewController {
    fileprivate func opendDetailViewController() {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "LocationDetailViewController") as? LocationDetailViewController {
            detailViewController.modalPresentationStyle = .overCurrentContext
            detailViewController.modalTransitionStyle = .crossDissolve
            detailViewController.location = locationManager.location?.coordinate
            self.present(detailViewController
                , animated: true, completion: nil)
            
        }
    }
    
    func addPin(coordinate: CLLocationCoordinate2D) {
        let annotation  = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    func reAskLocationPermission() {
        let alert = UIAlertController(title: "Uyarı", message: "Uygulamayı daha etkin kullanabilmek için lütfen konum izni veriniz.", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Ayarlara git.", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "İzin vermeden devam et.", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
