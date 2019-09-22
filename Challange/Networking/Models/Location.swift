//
//  Location.swift
//  Challange
//
//  Created by Selahattin Cincin on 21.09.2019.
//  Copyright © 2019 Selahattin Cincin. All rights reserved.
//

import Foundation

struct Location: Codable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "myLongitude"
        case latitude = "myLatitude"
    }
    
    func transformToData() -> Data? {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(self)
        } catch {
            return nil
        }
    }
    
}
