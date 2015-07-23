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
    struct CityImage{
        var badge: UIImage
        var portrait: UIImage
    }
    
    var cities: OrderedDictionary<String, CityImage>
    var badgeCities: [String]
    var defaults: NSUserDefaults
    var onlineVersion: Int?
    var localVersion: Int = 0
    
    init(defaults: NSUserDefaults){
        self.cities = OrderedDictionary<String, CityImage>()
        self.badgeCities = []
        self.defaults = defaults
        
        var version: Int? = defaults.objectForKey("cityListVersion") as? Int
        if version != nil {
            self.localVersion = version!
        }
    }
    
    func loadList(finishHandler: () -> Void) {
        onlineVersion = getOnlineVersion()
        loadBadgeList(finishHandler)
    }
    
    func achieveBadge(city name: String) {
        var badge: PFObject = PFObject(className: "UserBadges")
        badge["username"] = PFUser.currentUser()!.username! as String
        badge["city"] = name
        badge.save()
        
        badgeCities += [name]
    }
    
    func loadBadgeStates(){
        if self.badgeCities.count > 0 {
            return
        }
        
        var query: PFQuery = PFQuery(className: "UserBadges")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username! as String)
        
        let objects: [AnyObject]? = query.findObjects()
        if objects != nil {
            let badges: [PFObject] = objects as! [PFObject]
            for badge in badges {
                badgeCities += [badge["city"] as! String]
            }
        }
    }
    
    private func loadBadgeList(finishHandler: () -> Void){
        var query: PFQuery = PFQuery(className: "Cities")
            query.whereKey("name", notEqualTo: "")
            query.orderByAscending("name")
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if objects != nil {
                var pfObjects: [PFObject] = objects as! [PFObject]
                for cityObject in pfObjects {
                    var badgeImage: UIImage?
                    var portraitImage: UIImage?
                    var name: String = cityObject["name"] as! String
                    
                    if self.localVersion < self.onlineVersion! {
                        badgeImage = self.loadAndSaveBadgeImage("badge_\(name)", imageFile: cityObject["badge"] as! PFFile)
                        portraitImage = self.loadAndSaveBadgeImage("portrait_\(name)", imageFile: cityObject["portrait"] as! PFFile)
                    } else {
                        badgeImage = self.loadChachedBadge("badge_\(name)")
                        portraitImage = self.loadChachedBadge("portrait_\(name)")
                    }
                    
                    var cityImages: CityImage = CityImage(badge: badgeImage!, portrait: portraitImage!)
                    self.cities[name] = cityImages
                }
                
                self.defaults.setInteger(self.onlineVersion!, forKey: "cityListVersion")
                finishHandler()
            }
        }
    }
    
    private func loadAndSaveBadgeImage(var name: String, imageFile: PFFile) -> UIImage {
        name = name.stringByReplacingOccurrencesOfString(" ", withString: "_")
        
        var image: UIImage = UIImage(data:imageFile.getData()!)!
        var imageData: NSData = UIImagePNGRepresentation(image)
        self.defaults.setObject(imageData, forKey: name)

        return image
    }
    
    private func loadChachedBadge(var name: String) -> UIImage{
        name = name.stringByReplacingOccurrencesOfString(" ", withString: "_")
        
        return UIImage(data:self.defaults.valueForKey(name) as! NSData)!
    }
    
    private func getOnlineVersion() -> Int {
        var query: PFQuery = PFQuery(className: "Version")
        return query.getFirstObject()!["version"] as! Int
    }
}