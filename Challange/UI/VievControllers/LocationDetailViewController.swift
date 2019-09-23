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
        if let latitute = location?.latitude {
            latituteInfo.text = "Enlem:\(String(describing: latitute))"
        }
        if let longitute = location?.longitude {
            longituteInfo.text = "Boylam:\(String(describing: longitute))"
        }
      
        
        
    }
    @IBAction func tappedShare(_ sender: Any) {
        let alert = UIAlertController(title: "Uyarı", message: "Konumunuzu paylaşmak üzeresiniz!", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Vazgeç", style: .cancel) { (action) in
            print("Canceled")
        }
        let actionSend = UIAlertAction(title: "Gönder", style: .default) { (action) in
            self.sendLocation()
        }
        alert.addAction(actionCancel)
        alert.addAction(actionSend)
        present(alert, animated: true, completion: nil)
        
        
    }
    private func sendLocation() {
        guard let longitude: Double = location?.longitude,
            let latitude: Double = location?.latitude else { return }
        let mlocation = Location(longitude: longitude, latitude: latitude)
        locationService.sendLocation(location: mlocation) {[weak self] response in
            guard let strongSelf = self else { return }
            if let response = response, let status = response.success, status {
                strongSelf.showMessage("Konumunuz başarı ile gönderildi.")
            } else {
                strongSelf.showMessage("Konumunuz gönderilirken bir hata oluştu.")
            }
            
        }
    }
    
}


extension LocationDetailViewController {
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "", message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
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
