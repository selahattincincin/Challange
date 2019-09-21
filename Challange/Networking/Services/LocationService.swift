//
//  LocationService.swift
//  Challange
//
//  Created by Selahattin Cincin on 21.09.2019.
//  Copyright © 2019 Selahattin Cincin. All rights reserved.
//

import Foundation


class LocationService {
    
    func sendLocation(location: Location,completion: @escaping () -> Void) {
        let sendLocationRequest = SendLocationRequest(location: location)
        guard let request = sendLocationRequest.request else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            }.resume()
    }
}
