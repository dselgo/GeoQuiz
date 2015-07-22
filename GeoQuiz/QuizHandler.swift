//
//  QuizHandler.swift
//  parseDataLoad
//
//  Created by Deforation on 22.07.15.
//  Copyright (c) 2015 teamF. All rights reserved.
//

import Foundation
import Parse

struct QuizQuestion {
    var text: String
    var answers: (answer1: String, answer2: String, answer3: String, answer4: String)
    var correctAnswer: Int
    var image: PFFile
}

class QuizHandler{
    var location: String
    var numberOfQuestions: Int
    var questionNumber: Int
    var questionId: Int64
    
    init(location: String, numberOfQuestions: Int, startQuestionID: Int64){
        self.location = location
        self.numberOfQuestions = numberOfQuestions
        self.questionId = startQuestionID
        self.questionNumber = 1
    }
    
    private func nextQuestionAvailable() -> Bool {
        return questionNumber <= numberOfQuestions
    }
    
    func getNextQuestion(imageHandler: (image: UIImage) -> Void) -> QuizQuestion?{
        var question: QuizQuestion?
        
        if nextQuestionAvailable() {
            question = loadQuestion(questionId)
            if question != nil {
                loadQuestionImage(question!.image, imageHandler: imageHandler)
            }
        }
        ++questionId
        
        return question
    }
    
    private func loadQuestion(id: Int64) -> QuizQuestion? {
        var query: PFQuery = PFQuery(className: self.location)
        var pfQuestion: PFObject?
        
        query.whereKey("questionId", equalTo: String(id))
        pfQuestion = query.findObjects()?.first as? PFObject
        
        return self.parseQuestion(pfQuestion)
    }
    
    private func loadQuestionImage(imageFile: PFFile, imageHandler: (image: UIImage) -> Void) {
        imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                imageHandler(image: UIImage(data:imageData!)!)
            }
        })
    }
    
    func parseQuestion(pfQuestion: PFObject?) -> QuizQuestion? {
        var question: QuizQuestion?
        
        if (pfQuestion != nil){
            var text: String = pfQuestion!["question"] as! String
            var image: PFFile = pfQuestion!["image"] as! PFFile
            var answer1: String = pfQuestion!["answer1"] as! String
            var answer2: String = pfQuestion!["answer2"] as! String
            var answer3: String = pfQuestion!["answer3"] as! String
            var answer4: String = pfQuestion!["answer4"] as! String
            var correctAnswer: Int = pfQuestion!["correctAnswer"] as! Int
            question = QuizQuestion(text: text, answers: (answer1, answer2, answer3, answer4), correctAnswer: correctAnswer, image: image)
        }
        
        return question
    }
}