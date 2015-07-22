//
//  GeoLocation.swift
//  parseDataLoad
//
//  Created by Deforation on 22.07.15.
//  Copyright (c) 2015 teamF. All rights reserved.
//

import Foundation
import CoreLocation


class GeoLocation {
    private func getLocation() -> CLLocation? {
        var locatioManager: CLLocationManager = CLLocationManager()
        locatioManager.desiredAccuracy = kCLLocationAccuracyBest
        locatioManager.requestAlwaysAuthorization()
        locatioManager.startUpdatingLocation()
        return locatioManager.location
    }
    
    func getLocation(locationHandler: (String?) -> Void) {
        var location: CLLocation? = getLocation()
        
        println(location?.coordinate.latitude)
        println(location?.coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                locationHandler(nil)
                println("Reverse geocoder failed with error" + error.localizedDescription)
            } else {
            
                if placemarks.count > 0 {
                    let pm: CLPlacemark = placemarks[0] as! CLPlacemark
                    locationHandler(pm.locality)
                }
                else {
                    locationHandler(nil)
                }
            }
        })
    }
}