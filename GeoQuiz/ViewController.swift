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

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var badgesButton: UIButton!
    @IBOutlet weak var citySearchBar: UISearchBar!
    
    let borderSize : CGFloat = 0.7
    let cornerRadius : CGFloat = 5.0
    var geoLocation: GeoLocation?
    var cities: [String] = []
    var cityHandler: CityHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.layer.borderWidth = 1.0
        playButton.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        playButton.layer.cornerRadius = cornerRadius
        optionsButton.layer.borderWidth = 1.0
        optionsButton.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        optionsButton.layer.cornerRadius = cornerRadius
        badgesButton.layer.borderWidth = 1.0
        badgesButton.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        badgesButton.layer.cornerRadius = cornerRadius
        
        geoLocation = GeoLocation()
        cityHandler = CityHandler(defaults: NSUserDefaults.standardUserDefaults())
        //loadCityList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initializeStartScreen()
    }
    
    @IBAction func locationButtonPressed(sender: UIButton) {
        var geoLocation: GeoLocation = GeoLocation()
        let currentLocation: PFGeoPoint? = geoLocation.getLocation()
        
        if currentLocation != nil {
            var query: PFQuery = PFQuery(className: "Cities")
            
            query.whereKey("location", nearGeoPoint: currentLocation!)
            
            var cityObject: PFObject? = query.findObjects()?.first as? PFObject
            citySearchBar.text = cityObject!["name"] as! String
        } else {
            var alert: UIAlertView = UIAlertView(title: "Location error", message: "Could not detect your current position. Pleasy try again.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
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
        loginCtrl.facebookPermissions = ["friends_about_me"]
        loginCtrl.logInView?.logo = logInLogoTitle
        loginCtrl.delegate = self
            
        var signupCtrl = PFSignUpViewController()
        signupCtrl.signUpView?.logo = signUpLogoTitle
        signupCtrl.delegate = self
        loginCtrl.signUpController = signupCtrl
            
        self.presentViewController(loginCtrl, animated: true, completion: nil)
    }
    
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if count(username) > 0 && count(password) > 0 {
            return true;
        }
        
        var alert = UIAlertView(title: "Missing login info", message: "Make sure you fill in the username and password!", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        
        return false
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        if error != nil {
            var alert: UIAlertView = UIAlertView(title: error?.localizedDescription, message: "Please check your credentials or use (Sign Up) to create a new account", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}

