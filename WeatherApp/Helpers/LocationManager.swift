//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Juan Garcia on 12/17/18.
//  Copyright © 2018 Juan Garcia. All rights reserved.
//

import Foundation
import MapKit
import RxSwift

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    
    //TODO: Replace with a model object
    typealias placeData = (city: String, country: String, countryCode: String)
    fileprivate let placeSubject = PublishSubject<placeData>()
    var place: Observable<placeData> {
        return placeSubject.asObserver()
    }
    
    // MARK: Public methods
    func requestLocationPermissions() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestLocation()
        }
    }
    
    func getLocationName(location: CLLocation) {
        fetchCityAndCountry(from: location) { [weak self] city, country, countryCode, error in
            guard let city = city,
                let country = country,
                let countryCode = countryCode,
                error == nil else {
                print("Error occurred while fetching city and country")
                self?.placeSubject.onError(error!)
                return
            }

            print(city + ", " + country) // Rio de Janeiro, Brazil
            self?.placeSubject.onNext((city, country, countryCode))
        }
    }
}

// MARK: - Location manager delegate
extension LocationManager: CLLocationManagerDelegate {
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ countryCode: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       placemarks?.first?.isoCountryCode,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            print("Warning: location is nil")
            return
        }
        print("locations count:", locations.count)
        getLocationName(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        //TODO: In case of error display the last recent location
        placeSubject.onNext((city: "Montevideo", country: "Uruguay", countryCode: "UY"))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            getCurrentUserLocation()
        } else {
            //TODO: If location was denied show an alert to change the selection on Device Settings.
            placeSubject.onNext((city: "Montevideo", country: "Uruguay", countryCode: "UY"))
        }
    }
}
