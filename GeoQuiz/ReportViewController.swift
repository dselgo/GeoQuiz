//
//  QuestionViewController.swift
//  GeoQuiz
//
//  Created by Deforation on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit
import Parse

class ReportViewController: UIViewController {
    
    @IBOutlet weak var reportText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var questionNumber: Int = 0
    var location: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitQuestion(sender: AnyObject) {
        var pfItem = PFObject(className: "Report")
        pfItem["city"] = location
        pfItem["questionId"] = questionNumber
        pfItem["description"] = reportText.text
        pfItem.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if success {
                println("report was successfully saved")
            }
            else {
                println("report was NOT saved")
            }
        }
    }
}
