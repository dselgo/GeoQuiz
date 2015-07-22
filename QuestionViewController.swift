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
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var nextButton: UIButton!

    let borderSize : CGFloat = 0.7
    let cornerRadius : CGFloat = 5.0
    
    var timer = NSTimer()
    var counter: Double = 10.0
    let decrementTime: Double = 0.1
    
    var gameOver: Bool = false
    var roundOver: Bool = false
    
    let location: String = ""
    
    var question: Question! = nil
    var questionNumber: Int = 0
    
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
        runQuiz()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func runQuiz(){
        if (location != ""){
            let quiz = QuizHandler(location: location ,startQuestionID: 1)
            while(!gameOver){
                question = quiz.getNextQuestion()!
                questionNumber = quiz.questionNumber
                questionText.text = question.text
                answer1Button.setTitle(question.answers[0].text, forState: UIControlState.Normal)
                answer2Button.setTitle(question.answers[1].text, forState: UIControlState.Normal)
                answer3Button.setTitle(question.answers[2].text, forState: UIControlState.Normal)
                answer4Button.setTitle(question.answers[3].text, forState: UIControlState.Normal)
                
                startTimer()
                roundOver = false
                
                while(!roundOver){}
                
            }
        }
    }
    
    func startTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(decrementTime, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: false)
    }
    
    func updateTimer(){
        counter -= decrementTime
        //add code to update label here
        if(counter <= 0){
            stopTimer()
        }
    }
    
    //stops the timer when it reached 0 and highlights the correct answer
    func stopTimer(){
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
    }
    
    //stops the timer and checks if the button pressed was correct
    func stopTimer(sender: UIButton!){
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
    }
}
