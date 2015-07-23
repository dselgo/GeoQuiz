//
//  ResultViewController.swift
//  GeoQuiz
//
//  Created by Deforation on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit
//import XYPieChart
import Parse

class ResultViewController: UIViewController {
    
    @IBOutlet weak var numCorrectLabel: UILabel!
    @IBOutlet weak var numCorrectProgessBar: UIProgressView!
    var location: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonPushed(sender: UIButton) {
    }
    @IBAction func facebookButtonPushed(sender: UIButton) {
        let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        photo.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photo.userGenerated = true
        let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content.photos = [photo]
    }
    
    @IBAction func tryAgainButtonPushed(sender: AnyObject) {
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}




