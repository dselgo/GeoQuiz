//
//  QuizHandler.swift
//  parseDataLoad
//
//  Created by Deforation on 22.07.15.
//  Copyright (c) 2015 teamF. All rights reserved.
//

import Foundation
import Parse

class QuizHandler{
    var location: String
    var numberOfQuestions: Int
    var questionNumber: Int
    var questionId: Int64
    var questionCount: Int?
    
    /**
    * Initializes the QuizHandler which loads questions from Parse.com
    *
    * Params:
    * location: Location for which questions should be loaded
    * startQuestionId: question id of the first questiion
    */
    init(location: String, startQuestionID: Int64){
        self.location = location.stringByReplacingOccurrencesOfString(" ", withString: "_") + "_" + NSLocalizedString("LANGUAGE_SHORTCUT", comment: "EN")
        self.numberOfQuestions = 10
        self.questionId = startQuestionID
        self.questionNumber = 1
    }
    
    /**
    * Checks if one more question is available
    *
    * Return Value:
    * True if there is a question available, otherwise false
    */
    func nextQuestionAvailable() -> Bool {
        if questionCount == nil {
            self.questionCount = self.getQuestionCount()
        }
        
        return questionNumber <= numberOfQuestions && questionNumber <= questionCount!
    }
    
    /**
    * Returns the number of available Questions for the current Country
    *
    * Return Value:
    * maximum question id
    */
    func getQuestionCount() -> Int {
        var query: PFQuery = PFQuery(className: location)
        query.orderByDescending("questionId")
        query.limit = 1
        
        var pfCount: PFObject = (query.findObjects()?.first as? PFObject)!
        
        return (pfCount["questionId"] as! String).toInt()!
    }
    
    /**
    * Returns the next question in the question queue
    *
    * Params:
    * imageHandler: Closure function which will retrieve the image
    *
    * Return Value:
    * Question Object with the next question
    */
    func getNextQuestion(imageHandler: (image: UIImage) -> Void) -> Question?{
        var question: Question?
        
        if nextQuestionAvailable() {
            question = loadQuestion(questionId)
            if question?.image != nil {
                loadQuestionImage(question!.image!, imageHandler: imageHandler)
            }
        }
        ++questionId
        ++questionNumber
        
        return question
    }
    
    /**
    * Loads the Question with the given ID
    *
    * Params:
    * id: Question to load
    *
    * Return Value:
    * Question Object
    */
    private func loadQuestion(id: Int64) -> Question? {
        var query: PFQuery = PFQuery(className: self.location)
        var pfQuestion: PFObject?
        
        query.whereKey("questionId", equalTo: String(id))
        pfQuestion = query.findObjects()?.first as? PFObject
        
        return self.parseQuestion(pfQuestion)
    }
    
    /**
    * Parses a Question object from Parse.com
    * So it returns a Question Struct
    *
    * Params:
    * pfQuestion: Parses the Parse.com question Object to a Question Struct
    *
    * Return Value:
    * Question Object
    */
    func parseQuestion(pfQuestion: PFObject?) -> Question? {
        var question: Question?
        
        if (pfQuestion != nil){
            var text: String = pfQuestion!["question"] as! String
            var image: PFFile? = pfQuestion!["image"] as? PFFile
            var answer1: String = pfQuestion!["answer1"] as! String
            var answer2: String = pfQuestion!["answer2"] as! String
            var answer3: String = pfQuestion!["answer3"] as! String
            var answer4: String = pfQuestion!["answer4"] as! String
            var correctAnswer: Int = pfQuestion!["correctAnswer"] as! Int
            
            if(image != nil){
                question = Question(text: text, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, correctAnswer: correctAnswer, image: image!)
            } else {
                question = Question(text: text, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, correctAnswer: correctAnswer)
            }
        }
        
        return question
    }
    
    /**
    * Loads the image of a question asynchronously and calls the closure function when it is finished
    *
    * Params:
    * imageFile: ClosureFunction which retrieves the downloaded Image
    */
    private func loadQuestionImage(imageFile: PFFile, imageHandler: (image: UIImage) -> Void) {
        imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                imageHandler(image: UIImage(data:imageData!)!)
            }
        })
    }
}