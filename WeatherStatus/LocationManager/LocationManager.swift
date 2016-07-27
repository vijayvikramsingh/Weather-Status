//
//  LocationManager.swift
//  WeatherStatus
//
//  Created by Vijay Singh on 25/07/16.
//  Copyright © 2016 Vijay Singh. All rights reserved.
//

import UIKit


import Foundation
import CoreLocation

enum ErrorType {
    case NotAuthorized
    case NoNetworkError
    case OtherError
}

protocol LocationManagerDelegate {
    func fetchedLocation(currentLocation: String)
    func locationFetchingDidFailWithErrorType(error: ErrorType)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    class var sharedInstance: LocationManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            
            static var instance: LocationManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LocationManager()
        }
        return Static.instance!
    }
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {

            if #available(iOS 8.0, *) {
                locationManager.requestAlwaysAuthorization()
            } else {
            }
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        self.stopUpdatingLocation()
        self.lastLocation = location
        updateLocation(location)
        print("didupdatlocations called")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        updateLocationDidFailWithErrorType(ErrorType.OtherError)
    }
    
    //MARK: Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        if  !Utils.isNetworkReachable() {
            self.updateLocationDidFailWithErrorType(ErrorType.NoNetworkError)
            return
        }
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks, error) in
            if error == nil {
            let pm = placemarks! as [CLPlacemark]
            if (pm.count > 0){
                if let p = pm.first {
                    if let city = p.locality {
                        delegate.fetchedLocation(city)
                    }
                    else if let country = p.country {
                        delegate.fetchedLocation(country)
                       }
                }
             }
            }
            else {
                self.updateLocationDidFailWithErrorType(ErrorType.OtherError)
            }
        })
    }
    
    private func updateLocationDidFailWithErrorType(error: ErrorType) {
        
        guard let delegate = self.delegate else {
            return
        }
        if !CLLocationManager.locationServicesEnabled() || !self.isLocationServicesAuthorized() {
            delegate.locationFetchingDidFailWithErrorType(ErrorType.NotAuthorized)
        }
        else {
            delegate.locationFetchingDidFailWithErrorType(error)
        }
    }
    
    func isLocationServicesAuthorized() -> Bool {
        var isAuthorized = true
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            isAuthorized = false
        case .Restricted:
            isAuthorized = false
        case .Denied:
            isAuthorized = false
        default:
            isAuthorized = true
        }
        return isAuthorized
    }

}
