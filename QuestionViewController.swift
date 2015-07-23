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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionImage: UIImageView!

    let borderSize : CGFloat = 0.7
    let cornerRadius : CGFloat = 5.0
    
    var timer = NSTimer()
    var counter: Double = 10.0
    let decrementTime: Double = 0.1
    
    var location: String = ""
    
    var question: Question! = nil
    var questionNumber: Int = 0
    
    var quiz: QuizHandler! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answer1Button.layer.borderWidth = 1.0
        answer1Button.layer.cornerRadius = cornerRadius
        answer1Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer1Button.addTarget(self, action: "stopTimer:", forControlEvents: UIControlEvents.TouchDown)
        answer2Button.layer.borderWidth = 1.0
        answer2Button.layer.cornerRadius = cornerRadius
        answer2Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer2Button.addTarget(self, action: "stopTimer:", forControlEvents: UIControlEvents.TouchDown)
        answer3Button.layer.borderWidth = 1.0
        answer3Button.layer.cornerRadius = cornerRadius
        answer3Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer3Button.addTarget(self, action: "stopTimer:", forControlEvents: UIControlEvents.TouchDown)
        answer4Button.layer.borderWidth = 1.0
        answer4Button.layer.cornerRadius = cornerRadius
        answer4Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer4Button.addTarget(self, action: "stopTimer:", forControlEvents: UIControlEvents.TouchDown)
        if (location != ""){
            quiz = QuizHandler(location: location, startQuestionID: 1)
            loadQuestion()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadQuestion(){
        nextButton.enabled = false
        answer1Button.enabled = true
        answer2Button.enabled = true
        answer3Button.enabled = true
        answer4Button.enabled = true
        counter = 10.0
        question = quiz.getNextQuestion({ (image) -> Void in
            self.questionImage.image = image
        })!
        questionNumber = quiz.questionNumber
        questionText.text = question.text
        
        answer1Button.setTitle(question.answers[0].text, forState: UIControlState.Normal)
        answer2Button.setTitle(question.answers[1].text, forState: UIControlState.Normal)
        answer3Button.setTitle(question.answers[2].text, forState: UIControlState.Normal)
        answer4Button.setTitle(question.answers[3].text, forState: UIControlState.Normal)
        
        startTimer()
    }
    
    func startTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(decrementTime, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    func updateTimer(){
        counter -= decrementTime
        timerLabel.text = String(stringInterpolationSegment: counter)
        if(counter <= 0){
            timerLabel.text = "0.0"
            stopTimer()
        }
    }
    
    //stops the timer when it reached 0 and highlights the correct answer
    func stopTimer(){
        answer1Button.enabled = false
        answer2Button.enabled = false
        answer3Button.enabled = false
        answer4Button.enabled = false
        timer.invalidate()
        if(question.answers[0].isCorrect){
            answer1Button.backgroundColor = UIColor.greenColor()
        } else if(question.answers[1].isCorrect){
            answer2Button.backgroundColor = UIColor.greenColor()
        } else if(question.answers[2].isCorrect){
            answer3Button.backgroundColor = UIColor.greenColor()
        } else {
            answer4Button.backgroundColor = UIColor.greenColor()
        }
        nextButton.enabled = true
    }
    
    //stops the timer and checks if the button pressed was correct
    func stopTimer(sender: UIButton!){
        answer1Button.enabled = false
        answer2Button.enabled = false
        answer3Button.enabled = false
        answer4Button.enabled = false
        timer.invalidate()
        if(question.answers[0].isCorrect){
            answer1Button.backgroundColor = UIColor.greenColor()
            if(sender != answer1Button){
                sender.backgroundColor = UIColor.redColor()
            }
        } else if(question.answers[1].isCorrect){
            answer2Button.backgroundColor = UIColor.greenColor()
            if(sender != answer2Button){
                sender.backgroundColor = UIColor.redColor()
            }
        } else if(question.answers[2].isCorrect){
            answer3Button.backgroundColor = UIColor.greenColor()
            if(sender != answer3Button){
                sender.backgroundColor = UIColor.redColor()
            }
        } else {
            answer4Button.backgroundColor = UIColor.greenColor()
            if(sender != answer4Button){
                sender.backgroundColor = UIColor.redColor()
            }
        }
        nextButton.enabled = true
    }
    
    @IBAction func nextQuestion(sender: AnyObject) {
        if(quiz.nextQuestionAvailable()){
            loadQuestion()
            answer1Button.backgroundColor = UIColor.clearColor()
            answer2Button.backgroundColor = UIColor.clearColor()
            answer3Button.backgroundColor = UIColor.clearColor()
            answer4Button.backgroundColor = UIColor.clearColor()
            questionImage.image = nil
        } else {
            //segue into resultView
        }
    }
}
