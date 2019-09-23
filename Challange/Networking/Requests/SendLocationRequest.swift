//
//  File.swift
//  Challange
//
//  Created by Selahattin Cincin on 21.09.2019.
//  Copyright © 2019 Selahattin Cincin. All rights reserved.
//

import Foundation


class SendLocationRequest {
    let  location: Location
    var request: URLRequest?
    
    init(location: Location) {
        self.location = location
        guard let url = URL(string: "http://tarimsalfaaliyetler.com/json/reply/savelocationrequest?latitute=\(location.latitude)&longitude=\(location.longitude)") else { return }
        request = URLRequest(url: url)
        request?.httpMethod = "GET"
        
    
    }
}
