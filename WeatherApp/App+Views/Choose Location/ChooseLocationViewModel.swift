//
//  ChooseLocationViewModel.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/17/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation

enum LocationSections: Int {
    case current = 0
    case recent
}

class ChooseLocationViewModel {
    
    //TODO: Store and get this data from NSUserDefaults
    let recentLocation = [
        Location("Montevideo", "Uruguay", "UY"),
        Location("London", "England, United Kindom", "UK"),
        Location("São Paulo", "Brazil", "BR"),
        Location("Buenos Aires", "Argentina", "AR"),
        Location("Munich", "Germany", "DE")
    ]
}
