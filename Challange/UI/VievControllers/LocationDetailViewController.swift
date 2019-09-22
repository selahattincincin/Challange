//
//  LocationDetailViewController.swift
//  Challange
//
//  Created by Selahattin Cincin on 22.09.2019.
//  Copyright © 2019 Selahattin Cincin. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailViewController: UIViewController {
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var latituteInfo: UILabel!
    @IBOutlet weak var longituteInfo: UILabel!
    @IBOutlet var buttonShare: UIButton!
    
    var location: CLLocationCoordinate2D?
    let locationService = LocationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOffModal(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        popView.layer.cornerRadius = 10
        popView.layer.shadowRadius = 22
        popView.layer.shadowOffset = .zero
        popView.layer.shadowOpacity = 0.6
        
        buttonShare.layer.cornerRadius = 5
        buttonShare.layer.shadowRadius = 2
        buttonShare.layer.shadowOffset = .zero
        buttonShare.layer.shadowOpacity = 0.2
        
        latituteInfo.text = "Latitude:\(location!.latitude)"
        longituteInfo.text = "Longitude:\(location!.longitude)"
        
        
    }
    @IBAction func tappedShare(_ sender: Any) {
        let alert = UIAlertController(title: "Konumum", message: "\(String(describing: location!.latitude)) \(String(describing: location!.longitude))", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Canceled")
        }
        let actionSend = UIAlertAction(title: "Send", style: .default) { (action) in
            print("umarım gönderdi")
//            self.sendLocation()
        }
        alert.addAction(actionCancel)
        alert.addAction(actionSend)
        present(alert, animated: true, completion: nil)
        
        
    }
    private func sendLocation() {
//        guard let longitude: Double = locationManager.location?.coordinate.longitude,
//            let latitude: Double = locationManager.location?.coordinate.latitude else { return }
//        let location = Location(longitude: longitude, latitude: latitude)
//        locationService.sendLocation(location: location) {
//            print("bir şey oldu ama nee oldu daha anlamadık.")
//        }
    }
    
}

extension LocationDetailViewController {
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
    

extension LocationDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @objc func handleTapOffModal(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
