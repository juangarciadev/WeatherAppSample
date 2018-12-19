//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let dt: Int
    let main: WeatherMainData
    let wind: WeatherWind
    let weather: [WeatherCondition]
}
