//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/16/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation
import RxSwift

final class WeatherAPI: NSObject {
    
    static let shared = WeatherAPI()
    let disposeBag = DisposeBag()
    
    enum FailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    func getCurrentWeather(cityName: String) -> Observable<WeatherData> {
        
        return Observable.create { observer -> Disposable in
            guard let key = GlobalConfiguration.getOpenWeatherMapAPIKey() else {
                assertionFailure("Error: could not extract API key")
                return Disposables.create()
            }
            
            guard let sanitizedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                assertionFailure("Error: while sanitizing city name")
                return Disposables.create()
            }
            
            // Set up the URL request
            let endpointString = GlobalConfiguration.OpenWeatherMapURLString
            let parameters = [
                GlobalConfiguration.CityNameQueryParameter: sanitizedCityName,
                GlobalConfiguration.AppIdQueryParameter: key
            ]
            
            print("final request string:", endpointString)
            
            guard let url = URL(string: endpointString) else {
                print("error: URL NOT valid")
                return Disposables.create()
            }
            
            BaseAPI
                .request(url, parameters: parameters)
                .subscribe(onNext: { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            // if no error provided by alamofire return .notFound error instead.
                            observer.onError(response.error ?? FailureReason.notFound)
                            return
                        }
                        do {
                            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                            observer.onNext(weatherData)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = FailureReason(rawValue: statusCode) {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
