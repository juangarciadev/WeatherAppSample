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
    
    let disposeBag = DisposeBag()
    fileprivate let weatherDataVariable = Variable<WeatherData?>(nil)
    var weatherDataObservable: Observable<WeatherData?> {
        return weatherDataVariable.asObservable()
    }
    fileprivate let locationVariable = Variable<Location?>(nil)
    var locationObservable: Observable<Location?> {
        return locationVariable.asObservable()
    }
    //TODO: Create ServerError class
    fileprivate let errorSubject = PublishSubject<Error>()
    var errorObservable: Observable<Error> {
        return errorSubject.asObservable()
    }
    
    func getCurrentLocation() {
        let locationManager = LocationManager.shared
        
        locationManager.requestLocationPermissions()
        locationManager.locationObservable
            .subscribe(onNext: { [weak self] (location) in
                if let location = location {
                    self?.getCurrentWeather(for: location)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getCurrentWeather(for location: Location) {
        LocationManager.shared.stopGettingUserLocation()
        
        WeatherAPI.shared
            .getCurrentWeather(for: location.city, and: location.countryCode)
            .subscribe(onNext: { [weak self] weatherData in
                self?.locationVariable.value = location
                self?.weatherDataVariable.value = weatherData
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}
