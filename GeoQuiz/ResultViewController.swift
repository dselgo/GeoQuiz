//
//  ResultViewController.swift
//  GeoQuiz
//
//  Created by Deforation on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit
//import XYPieChart

class ResultViewController: UIViewController {
    
    @IBOutlet weak var numCorrectLabel: UILabel!
    @IBOutlet weak var numCorrectProgessBar: UIProgressView!
    
    var numQuestions: Int!
    var numQuestionsCorrect: Int!
    var quizLocation: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numCorrectLabel.text = "Number of Questions Right: \(numQuestionsCorrect)"
        var percentage = Float(numQuestionsCorrect)/Float(numQuestions)
        numCorrectProgessBar.progress = percentage
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
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}




