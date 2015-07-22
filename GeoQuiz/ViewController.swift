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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initializeStartScreen()
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

