//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation
import RxSwift

class WeatherViewModel {
    
    lazy var locationManager = LocationManager()
    let disposeBag = DisposeBag()
    
    func getCurrentLocation() {
        locationManager.requestLocationPermissions()
        
        locationManager.place
            .subscribe(onNext: { [weak self] (result) in
                self?.getCurrentWeather(result.city)
                }, onError: { (error) in
                    //TOOD: Show error alert
                    print(error)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func getCurrentWeather(_ cityName: String) {
        WeatherAPI.shared
            .getCurrentWeather(cityName: cityName)
            .subscribe(onNext: { response in
                print(response)
            })
            .disposed(by: disposeBag)
    }
}
