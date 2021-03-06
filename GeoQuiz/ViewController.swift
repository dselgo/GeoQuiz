//
//  ViewController.swift
//  GeoQuiz
//
//  Created by X Code User on 7/21/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var badgesButton: UIButton!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var locationActivity: UIActivityIndicatorView!
    @IBOutlet weak var locationButton: UIButton!
    
    let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    let borderSize: CGFloat = 0.7
    let cornerRadius: CGFloat = 5.0
    let borderWidth: CGFloat = 2.0
    var geoLocation: GeoLocation?
    var citiesFiltered: [String] = []
    var cityHandler: CityHandler?
    var searchActive: Bool = false
    var selectedCity: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GeoQuiz"
        
        playButton.layer.borderWidth = borderWidth
        playButton.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        playButton.layer.cornerRadius = cornerRadius
        optionsButton.layer.borderWidth = borderWidth
        optionsButton.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        optionsButton.layer.cornerRadius = cornerRadius
        badgesButton.layer.borderWidth = borderWidth
        badgesButton.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        badgesButton.layer.cornerRadius = cornerRadius
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
        citySearchBar.delegate = self
        playButton.enabled = false
        locationActivity.hidden = true
        locationButton.hidden = false
        
        loadCityList()
    }
    
    /**
    * Load all citys for the city list
    */
    func loadCityList(){
        dispatch_async(backgroundQueue, {
            self.cityHandler = CityHandler(defaults: NSUserDefaults.standardUserDefaults())
            self.cityHandler?.loadList({
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    self.cityTableView.reloadData()
                }
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initializeStartScreen()
    }
    
    /**
    * Action, when the location Button is pressed
    */
    @IBAction func locationButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
        self.startLocationActivityAnimation()
        dispatch_async(backgroundQueue, {
            self.searchCityAtCurrentLocation()
        })
    }
    
    /**
    * starts the get location activity
    * means, disable and enable buttons and start animating
    */
    func startLocationActivityAnimation(){
        locationActivity.hidden = false
        locationButton.hidden = true
        locationActivity.startAnimating()
    }
    
    /**
    * stopps the get location activity
    * means, disable and enable buttons and stop animating
    */
    func stopLocationActivityAnimation(){
        locationActivity.hidden = true
        locationButton.hidden = false
        locationActivity.stopAnimating()
    }
    
    /**
    * Returns the City for the Current Location
    * and searches it on the search bar
    */
    func searchCityAtCurrentLocation(){
        geoLocation = GeoLocation()
        let currentLocation: PFGeoPoint? = geoLocation!.getLocation()
        
        if currentLocation != nil {
            var query: PFQuery = PFQuery(className: "Cities")
            query.whereKey("location", nearGeoPoint: currentLocation!)
            
            var cityObject: PFObject? = query.findObjects()?.first as? PFObject
            
            dispatch_async(dispatch_get_main_queue()) {
                self.stopLocationActivityAnimation()
                self.citySearchBar.text = cityObject!["name"] as! String
                self.searchBar(self.citySearchBar, textDidChange: self.citySearchBar.text)
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                var alert: UIAlertView = UIAlertView(title: NSLocalizedString("LOCATION_ERROR_TITLE", comment: "Location Error"), message: NSLocalizedString("LOCATION_ERROR_MESSAGE", comment: "Location Error"), delegate: self, cancelButtonTitle: "OK")
                alert.show()
                self.stopLocationActivityAnimation()
            }
        }
    }
 
    /**
    * Handels the search bar
    */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.citiesFiltered = self.cityHandler!.cities.keys.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(citiesFiltered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        if citiesFiltered.count == 1{
            self.tableView(cityTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        } else {
            self.tableView(cityTableView, didSelectRowAtIndexPath: NSIndexPath())
        }
        
        
        self.cityTableView.reloadData()
    }
    
    /*
    * Initializes the start screen. If the user has no session open, the login screen will apper
    * Otherwise, GeoQuiz's start screen will be presented
    */
    func initializeStartScreen() {
        if PFUser.currentUser() == nil {
            setUpLoginScreen()
        }
    }
    
    /*
    * Sets the login screen up, which provides
    * a parse.com and a facebook login
    */
    func setUpLoginScreen(){
        var logInLogoTitle = UILabel()
        logInLogoTitle.text = "GeoQuiz"
        logInLogoTitle.font = UIFont(name: logInLogoTitle.font.fontName, size: 60)
        
        var signUpLogoTitle = UILabel()
        signUpLogoTitle.text = "GeoQuiz"
        signUpLogoTitle.font = UIFont(name: logInLogoTitle.font.fontName, size: 60)
        
        var loginCtrl = PFLogInViewController()
        loginCtrl.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.Facebook | PFLogInFields.SignUpButton
        loginCtrl.facebookPermissions = ["public_profile"]
        loginCtrl.logInView?.logo = logInLogoTitle
        loginCtrl.delegate = self
            
        var signupCtrl = PFSignUpViewController()
        signupCtrl.signUpView?.logo = signUpLogoTitle
        signupCtrl.delegate = self
        loginCtrl.signUpController = signupCtrl
            
        self.presentViewController(loginCtrl, animated: true, completion: nil)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if searchActive {
            return citiesFiltered.count
        } else {
            if cityHandler != nil {
                return cityHandler!.cities.count
            } else {
                return 0
            }
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cityCell", forIndexPath: indexPath) as! UITableViewCell
        var city: String!
        var image: UIImage!
        
        if searchActive {
            city = citiesFiltered[indexPath.row]
            image = cityHandler!.cities[city]?.portrait
        } else {
            city = cityHandler!.cities.keys[indexPath.row]
            image = cityHandler!.cities[city]?.portrait
        }
        
        cell.textLabel!.text = city
        cell.imageView!.image = image
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.length > 0 {
            if searchActive {
                selectedCity = citiesFiltered[indexPath.row]
            } else {
                selectedCity = cityHandler!.cities.keys[indexPath.row]
            }
            playButton.enabled = true
        } else {
            selectedCity = ""
            playButton.enabled = false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if count(username) > 0 && count(password) > 0 {
            return true;
        }
        
        var alert = UIAlertView(title: NSLocalizedString("SIGNUP_ERROR_TITLE", comment: "Signup Error"), message: NSLocalizedString("SIGNUP_ERROR_MESSAGE", comment: "Signup Error"), delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        
        return false
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        if error != nil {
            var alert: UIAlertView = UIAlertView(title: error?.localizedDescription, message: NSLocalizedString("LOGIN_ERROR_MESSAGE", comment: "Login Error"), delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    * Prepares the segue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if playButton == sender as! UIButton {
            var target: QuestionViewController = segue.destinationViewController as! QuestionViewController
            target.location = selectedCity
            target.quizLocation = selectedCity
        } else if badgesButton == sender as! UIButton {
            var target: BadgeTableViewController = segue.destinationViewController as! BadgeTableViewController
            target.cityHandler = cityHandler
            
            dispatch_async(backgroundQueue, {
                self.cityHandler?.loadBadgeStates()
                
                dispatch_async(dispatch_get_main_queue()) {
                    target.tableView.reloadData()
                }
            })
        }
    }
}

