//
//  Location.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/17/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation

/*
 Temperature is available in Fahrenheit, Celsius and Kelvin units.
 
 For temperature in Fahrenheit use units=imperial
 For temperature in Celsius use units=metric
 
 Temperature in Kelvin is used by default, no need to use units parameter in API call
 */
enum TemperatureScale: String {
    case celsius = "metric"
    case fahrenheit = "imperial"
    
    func symbolForScale() -> String {
        switch(self) {
        case .celsius:
            return "℃"
        case .fahrenheit:
            return "℉"
        }
    }
}

struct Location {
    let city: String
    let country: String
    let countryCode: String
    let tempScale: TemperatureScale
    
    init(_ city: String, _ country: String, _ countryCode: String, _ tempScale: TemperatureScale) {
        self.city = city
        self.country = country
        self.countryCode = countryCode
        self.tempScale = tempScale
    }
}
