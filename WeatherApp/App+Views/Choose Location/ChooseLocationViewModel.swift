//
//  ChooseLocationViewModel.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/17/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation

enum LocationSection: Int {
    case current = 0
    case recent
}

class ChooseLocationViewModel {
    
    //TODO: Store and get this data from NSUserDefaults
    let recentLocation = [
        Location("Montevideo", "Uruguay", "UY", .celsius),
        Location("London", "England, United Kindom", "UK", .celsius),
        Location("São Paulo", "Brazil", "BR", .fahrenheit),
        Location("Buenos Aires", "Argentina", "AR", .celsius),
        Location("Munich", "Germany", "DE", .celsius)
    ]
}
