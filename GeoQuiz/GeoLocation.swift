//
//  GeoLocation.swift
//  parseDataLoad
//
//  Created by Deforation on 22.07.15.
//  Copyright (c) 2015 teamF. All rights reserved.
//

import Foundation
import CoreLocation
import Parse

class GeoLocation {
    var locatioManager: CLLocationManager?
    
    init(){
        self.initLocationManager()
    }
    
    private func initLocationManager(){
        locatioManager = CLLocationManager()
        locatioManager!.desiredAccuracy = kCLLocationAccuracyBest
        locatioManager!.requestWhenInUseAuthorization()
        locatioManager!.startUpdatingLocation()
    }
    
    func getLocation() -> CLLocation? {
        initLocationManager()
        return locatioManager!.location
    }
    
    func getLocation() -> PFGeoPoint? {
        var location: CLLocation? = getLocation()
        if location == nil {
            return nil
        } else {
            return PFGeoPoint(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        }
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