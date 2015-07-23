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
    var localVersion: Int
    
    init(defaults: NSUserDefaults){
        self.cities = []
        self.defaults = defaults
        localVersion = 3
        //self.localVersion = defaults.objectForKey("cityListVersion") as! Int
    }
    
    func loadList() {
        onlineVersion = getOnlineVersion()
        loadDataOnline(localVersion < onlineVersion)
    }
    
    private func loadDataOnline(loadImagesLocally: Bool){
        /*
        var query: PFQuery = PFQuery(className: "Cities")
        query.whereKey("name", notEqualTo: "")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if objects != nil {
                var pfObjects: [PFObject] = objects as! [PFObject]
                for cityObject in pfObjects {
                    self.cities += [cityObject["name"] as! String]
                }
            }
        }
        */
    }
    
    private func getOnlineVersion() -> Int {
        var version: PFObject = PFObject(withoutDataWithClassName: "Version", objectId: "0CyJribthx")
        return version["version"] as! Int;
    }
    
}