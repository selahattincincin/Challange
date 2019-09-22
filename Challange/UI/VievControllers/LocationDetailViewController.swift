//
//  LocationDetailViewController.swift
//  Challange
//
//  Created by Selahattin Cincin on 22.09.2019.
//  Copyright © 2019 Selahattin Cincin. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {
    @IBOutlet weak var popView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOffModal(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        popView.layer.cornerRadius = 12
        popView.layer.shadowRadius = 22
        popView.layer.shadowOffset = .zero
        popView.layer.shadowOpacity = 0.6
        

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
