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
    @IBOutlet weak var mainMenuLabel: UIButton!
    @IBOutlet weak var tryAgainLabel: UIButton!
    
    let borderSize: CGFloat = 0.7
    let borderWidth: CGFloat = 2.0
    let cornerRadius: CGFloat = 5.0
    let backGroundColor: UIColor = UIColor.blueColor()
    
    var numQuestions: Int!
    var numQuestionsCorrect: Int!
    var quizLocation: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMenuLabel.layer.borderWidth = borderWidth
        mainMenuLabel.layer.cornerRadius = cornerRadius
        mainMenuLabel.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        mainMenuLabel.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        tryAgainLabel.layer.borderWidth = borderWidth
        tryAgainLabel.layer.cornerRadius = cornerRadius
        tryAgainLabel.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        tryAgainLabel.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        
        numCorrectLabel.text = "Number of Questions Right: \(numQuestionsCorrect)"
        var percentage = Float(numQuestionsCorrect)/Float(numQuestions)
        numCorrectProgessBar.progress = percentage
        
        enableBadgeIfAllCorrect()
    }

    func enableBadgeIfAllCorrect(){
        if numQuestionsCorrect == numQuestions {
            CityHandler.achieveBadge(city: quizLocation)
            var alert: UIAlertView = UIAlertView(title: NSLocalizedString("BADGE_UNLOCKED_TITLE", comment: "Badge Unlocked"), message: NSLocalizedString("BADGE_UNLOCKED_MESSAGE", comment: "Badge Unlocked: ") + quizLocation, delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonPushed(sender: UIButton) {
        
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




