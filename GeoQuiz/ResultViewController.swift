//
//  ResultViewController.swift
//  GeoQuiz
//
//  Created by Deforation on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit
import Parse
//import XYPieChart

class ResultViewController: UIViewController {
    
    @IBOutlet weak var numCorrectLabel: UILabel!
    @IBOutlet weak var numCorrectProgessBar: UIProgressView!
    @IBOutlet weak var facebookShareButton: UIButton!
    
    var numQuestions: Int!
    var numQuestionsCorrect: Int!
    var quizLocation: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numCorrectLabel.text = "Number of Questions Right: \(numQuestionsCorrect)"
        var percentage = Float(numQuestionsCorrect)/Float(numQuestions)
        numCorrectProgessBar.progress = percentage
        
        enableBadgeIfAllCorrect()
        
        var query: PFQuery = PFQuery(className: "Cities")
        var pfCity: PFObject?
        query.whereKey("name", equalTo: quizLocation)
        pfCity = query.findObjects()?.first as? PFObject
        
        var pfBadge: PFFile = pfCity!["badge"] as! PFFile
        //var badgeImage: UIImage = UIImage(data:pfBadge.getData()!)!
        
        let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        photo.image = UIImage(data:pfBadge.getData()!)!
        photo.userGenerated = true
        let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content.photos = [photo]
        
        let button : FBSDKShareButton = FBSDKShareButton()
        button.shareContent = content
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 100) * 0.5, 50, 100, 30)
        button.center = CGPointMake(self.view.center.x, self.view.center.y + 100)
        self.view.addSubview(button)
    }

    func enableBadgeIfAllCorrect(){
        if numQuestionsCorrect == numQuestions {
            CityHandler.achieveBadge(city: quizLocation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonPushed(sender: UIButton) {
        
    }
    
    @IBAction func facebookButtonPushed(sender: UIButton) {

    }
    
    @IBAction func tryAgainButtonPushed(sender: AnyObject) {
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "restartQuiz" {
        var target = (segue.destinationViewController as! QuestionViewController)
            target.location = quizLocation
            target.quizLocation = quizLocation
        }
    }
    
}




