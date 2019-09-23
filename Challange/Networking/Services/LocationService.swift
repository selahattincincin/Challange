//
//  LocationService.swift
//  Challange
//
//  Created by Selahattin Cincin on 21.09.2019.
//  Copyright © 2019 Selahattin Cincin. All rights reserved.
//

import Foundation


class LocationService {
    
    func sendLocation(location: Location,completion: @escaping (SendLocationResponse?) -> Void) {
        let sendLocationRequest = SendLocationRequest(location: location)
        guard let request = sendLocationRequest.request else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data{
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(SendLocationResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(response)
                    }
                    return
                } catch {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    
                    return
                }
            }
            DispatchQueue.main.async {
                completion(nil)
            }
            }.resume()
    }
}
