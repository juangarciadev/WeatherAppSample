//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation
import RxSwift

enum WeatherRow: Int {
    case condition = 0
    case mainData
    case detail
}

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
            .getCurrentWeather(for: location.city, location.countryCode, and: location.tempScale)
            .subscribe(onNext: { [weak self] weatherData in
                self?.locationVariable.value = location
                self?.weatherDataVariable.value = weatherData
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Table view helper methods
extension WeatherViewModel {
    
    func rows() -> Int {
        if weatherDataVariable.value != nil {
            return 3
        }
        
        return 0
    }
    
    func getHeight(for row: Int) -> CGFloat {
        switch WeatherRow(rawValue: row) {
        case .condition?:
            return 250
        default:
            return 70
        }
    }
    
    func getCondition() -> (temp: Double?, iconURL: URL?, description: String?) {
        let weatherData = weatherDataVariable.value
        let mainData = weatherData?.main
        let condition = weatherData?.weather.first
        
        var iconURL: URL? = nil
        if let iconID = condition?.icon {
            iconURL = WeatherAPI.shared.getIconURL(for: iconID)
        }
        
        return (mainData?.temp, iconURL, condition?.description.capitalized)
    }
    
    func getMainData() -> (humidity: Float?, tempMin: Double?, tempMax: Double?, windSpeed: Double?) {
        let weatherData = weatherDataVariable.value
        let mainData = weatherData?.main
        let wind = weatherData?.wind
        
        
        return (mainData?.humidity, mainData?.temp_min, mainData?.temp_max, wind?.speed)
    }
    
    //TOOD: Download more weather details to display
    func getDetail() -> (conditionTitle: String?, value: Int?) {
        let weatherData = weatherDataVariable.value
        let mainData = weatherData?.main
        
        return (.pressure, mainData?.pressure)
    }
}

private extension String {
    static let pressure = NSLocalizedString("Pressure", comment: "Title for cell")
}
