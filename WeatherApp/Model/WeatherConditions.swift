//
//  WeatherConditions.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation

struct WeatherConditions: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
