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
        guard let url = URL(string: "") else { return }
        request = URLRequest(url: url)
        request?.httpMethod = "POST"
        request?.httpBody = location.transformToData()
        
        request?.addValue("", forHTTPHeaderField: "")
        request?.addValue("", forHTTPHeaderField: "")
    }
}
