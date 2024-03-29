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
    var selectedAnnotation: MKPointAnnotation?
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setupPressRecogniser()
        
        locationButton.layer.cornerRadius = 5
        locationButton.layer.shadowRadius = 2
        locationButton.layer.shadowOffset = .zero
        locationButton.layer.shadowOpacity = 0.2
        
    }
    
    
    @IBAction func tappedShowLocation(_ sender: UIButton) {
        
        centerViewOnUserLocation()
        mapView.removeAnnotations(mapView.annotations)
        addPin(coordinate: locationManager.location!.coordinate)
        opendDetailViewController(coordinate: locationManager.location!.coordinate)
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
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            reAskLocationPermission()
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
        if let addedPin = mapView.annotations.first {
            if addedPin.coordinate.latitude == coordinate.latitude && addedPin.coordinate.longitude == coordinate.longitude {
                return
            }
        }
        mapView.removeAnnotations(mapView.annotations)
        addPin(coordinate: coordinate)
        opendDetailViewController(coordinate: coordinate)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
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
        annotationView.frame.size =  CGSize(width: 28, height: 36)
        return annotationView
    }
}


extension MapViewController {
    fileprivate func opendDetailViewController(coordinate: CLLocationCoordinate2D) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "LocationDetailViewController") as? LocationDetailViewController {
            detailViewController.modalPresentationStyle = .overCurrentContext
            detailViewController.modalTransitionStyle = .crossDissolve
            detailViewController.location = coordinate

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
