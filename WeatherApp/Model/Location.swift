//
//  Location.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/17/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation

struct Location: Codable {
    let city: String
    let country: String
    let countryCode: String
    
    init(_ city: String, _ country: String, _ countryCode: String) {
        self.city = city
        self.country = country
        self.countryCode = countryCode
    }
}
