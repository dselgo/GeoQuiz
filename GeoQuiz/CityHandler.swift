//
//  CityHandler.swift
//  GeoQuiz
//
//  Created by Deforation on 23.07.15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import Foundation
import Parse

class CityHandler{
    struct city {
        var name: String
        var badge: UIImage
        var successful: Bool
    }
    
    var cities: [city]
    var defaults: NSUserDefaults
    var onlineVersion: Int?
    var localVersion: Int?
    
    init(defaults: NSUserDefaults){
        self.cities = []
        self.defaults = defaults
    }
    
    func loadList() {
        localVersion = defaults.objectForKey("cityListVersion") as! Int?
        onlineVersion = getOnlineVersion()
    }
    
    private func getOnlineVersion() -> Int {
        var version: PFObject = PFObject(withoutDataWithClassName: "Version", objectId: "0CyJribthx")
        return version["version"] as! Int;
    }
    
}