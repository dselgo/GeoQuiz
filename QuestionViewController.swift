//
//  QuestionViewController.swift
//  GeoQuiz
//
//  Created by Deforation on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    
    let borderSize : CGFloat = 0.7
    let cornerRadius : CGFloat = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answer1Button.layer.borderWidth = 1.0
        answer1Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer1Button.layer.cornerRadius = cornerRadius
        answer2Button.layer.borderWidth = 1.0
        answer2Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer2Button.layer.cornerRadius = cornerRadius
        answer3Button.layer.borderWidth = 1.0
        answer3Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer3Button.layer.cornerRadius = cornerRadius
        answer4Button.layer.borderWidth = 1.0
        answer4Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer4Button.layer.cornerRadius = cornerRadius
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
