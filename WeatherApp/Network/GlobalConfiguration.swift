//
//  GlobalConfiguration.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation

struct GlobalConfiguration {
    
    static func getOpenWeatherMapAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any], let key = dictionary["OpenWeatherAPIKey"] as? String {
            return key
        }
        return nil
    }
    
    static let OpenWeatherMapURLString = "https://api.openweathermap.org/data/2.5/weather"
    static let OpenWeatherMapAssetURLString = "http://openweathermap.org/img/w/"
    
    static let CityNameQueryParameter = "q"
    static let AppIdQueryParameter = "appid"
}
