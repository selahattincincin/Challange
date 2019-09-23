//
//  SendLocationResponse.swift
//  Challange
//
//  Created by Selahattin Cincin on 23.09.2019.
//  Copyright © 2019 Selahattin Cincin. All rights reserved.
//

import Foundation


class SendLocationResponse: Codable {
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        
    }
}
