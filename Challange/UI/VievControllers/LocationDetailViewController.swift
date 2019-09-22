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
    
    
    var location: CLLocationCoordinate2D?
    
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
        
        
        latituteInfo.text = "Latitude:\(location!.latitude)"
        longituteInfo.text = "Longitude:\(location!.longitude)"
        
        
    }

}

extension LocationDetailViewController {
    @IBAction func cancel_click(_ sender: Any) {
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
