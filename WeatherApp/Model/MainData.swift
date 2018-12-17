//
//  MainData.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation

struct MainData: Codable {
    let temp: Double
    let pressure: Int?
    let humidity: Float?
    let temp_min: Double?
    let temp_max: Double?
}
