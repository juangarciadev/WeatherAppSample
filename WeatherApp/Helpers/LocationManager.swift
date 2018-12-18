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
    private let locationManager = CLLocationManager()
    
    fileprivate let locationVariable = Variable<Location?>(nil)
    var locationObservable: Observable<Location?> {
        return locationVariable.asObservable()
    }
    var location: Location? {
        return locationVariable.value
    }
    
    // MARK: Lifecycle methods
    // Use singleton instance
    private override init(){}
    
    // MARK: Public methods
    func requestLocationPermissions() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func stopGettingUserLocation() {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestLocation()
        }
    }
    
    fileprivate func getLocationName(location: CLLocation) {
        fetchCityAndCountry(from: location) { [weak self] city, country, countryCode, error in
            guard let city = city,
                let country = country,
                let countryCode = countryCode,
                error == nil else {
                    print("Error occurred while fetching city and country")
                    return
            }
            
            print(city + ", " + country) // Rio de Janeiro, Brazil
            self?.locationVariable.value = Location(city, country, countryCode)
        }
    }
    
    fileprivate func showDefaultLocation() {
        locationVariable.value = Location("Montevideo", "Uruguay", "UY")
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
            showDefaultLocation()
            return
        }
        print("locations count:", locations.count)
        getLocationName(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        //TODO: In case of error display the last recent location
        showDefaultLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            getCurrentUserLocation()
        } else {
            //TODO: If location was denied show an alert to change the selection on Device Settings.
            showDefaultLocation()
        }
    }
}
