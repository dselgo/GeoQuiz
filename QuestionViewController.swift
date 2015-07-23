//
//  QuestionViewController.swift
//  GeoQuiz
//
//  Controller class for the quiz view.
//
//  Created by Remo Schweizer and Danny Selgo on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit
import AVFoundation

class QuestionViewController: UIViewController {
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    
    let borderSize: CGFloat = 0.7
    let borderWidth: CGFloat = 2.0
    let cornerRadius: CGFloat = 5.0
    let backGroundColor: UIColor = UIColor.blueColor()
    
    var timer = NSTimer()
    var counter: Double = 10.0
    let decrementTime: Double = 0.1
    
    var location: String = ""
    
    var question: Question! = nil
    var questionNumber: Int = 0
    var score: Int = 0
    var questionTotal = 0
    
    var correctSoundPath: NSURL! = nil
    var correctSound: AVAudioPlayer! = nil
    var wrongSoundPath: NSURL! = nil
    var wrongSound: AVAudioPlayer! = nil
    var soundsEnabled: Bool!
    var quizLocation: String!
    
    
    
    var quiz: QuizHandler! = nil
    
    /**
     * Load function that loads the view and then loads the first question
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        answer1Button.layer.borderWidth = borderWidth
        answer1Button.layer.cornerRadius = cornerRadius
        answer1Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer1Button.addTarget(self, action: "stopTimer:", forControlEvents: UIControlEvents.TouchDown)
        answer2Button.layer.borderWidth = borderWidth
        answer2Button.layer.cornerRadius = cornerRadius
        answer2Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer2Button.addTarget(self, action: "stopTimer:", forControlEvents: UIControlEvents.TouchDown)
        answer3Button.layer.borderWidth = borderWidth
        answer3Button.layer.cornerRadius = cornerRadius
        answer3Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer3Button.addTarget(self, action: "stopTimer:", forControlEvents: UIControlEvents.TouchDown)
        answer4Button.layer.borderWidth = borderWidth
        answer4Button.layer.cornerRadius = cornerRadius
        answer4Button.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        answer4Button.addTarget(self, action: "stopTimer:", forControlEvents: UIControlEvents.TouchDown)
        
        nextButton.layer.borderWidth = borderWidth
        nextButton.layer.cornerRadius = cornerRadius
        nextButton.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        reportButton.layer.borderWidth = borderWidth
        reportButton.layer.cornerRadius = cornerRadius
        reportButton.layer.borderColor = UIColor(white: 0.0, alpha: borderSize).CGColor
        
        self.questionText.editable = true
        self.questionText.font = UIFont(name: self.questionText.font.fontName, size: 13.5)
        self.questionText.editable = false
        
        resetControls()
        quiz = QuizHandler(location: location, startQuestionID: 1)
        
        correctSoundPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("soundCorrect", ofType: "wav")!)
        correctSound = AVAudioPlayer(contentsOfURL: correctSoundPath, error: nil)
        correctSound.prepareToPlay()
        
        wrongSoundPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("soundWrong", ofType: "wav")!)
        wrongSound = AVAudioPlayer(contentsOfURL: wrongSoundPath, error: nil)
        wrongSound.prepareToPlay()
        
        var defaults: NSUserDefaults = NSUserDefaults()
        if let enabled: AnyObject = defaults.objectForKey("SoundEnabled") {
            soundsEnabled = enabled as! Bool
        } else {
            soundsEnabled = true
        }
        
        loadQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * Gets the next question from the QuizHandler and then sets the question text to the text view, sets
     * the answers text to the buttons, and starts the timer.
     */
    func loadQuestion(){
        nextButton.enabled = false
        answer1Button.enabled = true
        answer2Button.enabled = true
        answer3Button.enabled = true
        answer4Button.enabled = true
        counter = 10.0
        
        dispatch_async(backgroundQueue, {
            self.question = self.quiz.getNextQuestion({ (image) -> Void in
                self.questionImage.image = image
            })
            
            self.questionNumber = self.quiz.questionNumber
            
            dispatch_async(dispatch_get_main_queue()) {
                self.questionText.text = self.question!.text
                
                self.answer1Button.setTitle(self.question.answers[0].text, forState: UIControlState.Normal)
                self.answer2Button.setTitle(self.question.answers[1].text, forState: UIControlState.Normal)
                self.answer3Button.setTitle(self.question.answers[2].text, forState: UIControlState.Normal)
                self.answer4Button.setTitle(self.question.answers[3].text, forState: UIControlState.Normal)
        
                self.startTimer()
            }
        })
    }
    
    /**
     * Begins the 10 second timer. Will fire an event every .1 seconds to update the timer label on the view
     */
    func startTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(decrementTime, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    /**
     * Called every time the timer fires to update the timer label on the view to the value of counter
     */
    func updateTimer(){
        counter -= decrementTime
        timerLabel.text = NSString(format: "%.1f", counter) as String
        if(counter <= 0){
            timerLabel.text = "0.0"
            stopTimer()
        }
    }
    
    /**
     * Method to stop the timer and update the UI when the timer reaches 0.
     * Plays a sound to notify that the user failed the question and highlights the correct answer in green.
     */
    func stopTimer(){
        answer1Button.enabled = false
        answer2Button.enabled = false
        answer3Button.enabled = false
        answer4Button.enabled = false
        timer.invalidate()
        if(question.answers[0].isCorrect){
            answer1Button.backgroundColor = UIColor.greenColor()
            playWrongSound()
        } else if(question.answers[1].isCorrect){
            answer2Button.backgroundColor = UIColor.greenColor()
            playWrongSound()
        } else if(question.answers[2].isCorrect){
            answer3Button.backgroundColor = UIColor.greenColor()
            playWrongSound()
        } else {
            answer4Button.backgroundColor = UIColor.greenColor()
            playWrongSound()
        }
        nextButton.enabled = true
    }
    
    /**
    * Method to stop the timer and update the UI when an answer button is pressed.
    * Plays a sound to notify that the user either failed the question  or answered it correctly.
    * Highlights the correct answer in green and the user selected answer in red if they answered incorrectly
    */
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
                playWrongSound()
            } else {
                playCorrectSound()
                score++
            }
        } else if(question.answers[1].isCorrect){
            answer2Button.backgroundColor = UIColor.greenColor()
            if(sender != answer2Button){
                sender.backgroundColor = UIColor.redColor()
                playWrongSound()
            } else {
                playCorrectSound()
                score++
            }
        } else if(question.answers[2].isCorrect){
            answer3Button.backgroundColor = UIColor.greenColor()
            if(sender != answer3Button){
                sender.backgroundColor = UIColor.redColor()
                playWrongSound()
            } else {
                playCorrectSound()
                score++
            }
        } else {
            answer4Button.backgroundColor = UIColor.greenColor()
            if(sender != answer4Button){
                sender.backgroundColor = UIColor.redColor()
                playWrongSound()
            } else {
                playCorrectSound()
                score++
            }
        }
        questionTotal++
        nextButton.enabled = true
    }
    
    /**
     * Plays a sound to notify the user that they answrred correctly
     */
    func playCorrectSound() {
        if soundsEnabled! {
            correctSound.play()
        }
    }
    
    /**
    * Plays a sound to notify the user that they answrred incorrectly
    */
    func playWrongSound() {
        if soundsEnabled! {
            wrongSound.play()
        }
    }
    
    /**
     * Resets the background color of the buttons and removes the image at the beginning of each question
     */
    func resetControls(){
        answer1Button.backgroundColor = backGroundColor
        answer2Button.backgroundColor = backGroundColor
        answer3Button.backgroundColor = backGroundColor
        answer4Button.backgroundColor = backGroundColor
        questionImage.image = nil
    }
    
    /**
     * Loads the next question into the UI when the Next button is pressed or loads the results view if there are no more questions
     */
    @IBAction func nextQuestion(sender: AnyObject) {
        if(quiz.nextQuestionAvailable()){
            loadQuestion()
            resetControls()
        } else {
            //segue into resultView
            performSegueWithIdentifier("showResults", sender: sender)
        }
    }
    
    /**
     * Segues to the report view to report a question
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if reportButton == sender as! UIButton {
            var target: ReportViewController = segue.destinationViewController as! ReportViewController
            target.location = location
            target.questionId = questionNumber - 1
        }

        if segue.identifier == "showResults"{
            var target = (segue.destinationViewController as! ResultViewController)
            target.numQuestionsCorrect = score
            target.numQuestions = questionTotal
            target.quizLocation = self.quizLocation
        }
    }
}
