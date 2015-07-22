//
//  Question.swift
//  GeoQuiz
//
//  Created by Danny on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import Foundation
import Parse

struct Answer{
    var text: String
    var isCorrect: Bool = false
}

class Question {
    var question: String
    var answers: [Answer](count: 4)
    var image: PFFile
    
    init(question: String, answer1: String, answer2: String, answer3: String, answer4: String, correctAnswer: Int){
        self.question = question
        answers[0].text = answer1
        answers[1].text = answer2
        answers[2].text = answer3
        answers[3].text = answer4
        switch correctAnswer {
            case 1:
                answers[0].isCorrect = true
            case 2:
                answers[1].isCorrect = true
            case 3:
                answers[2].isCorrect = true
            case 4:
                answers[3].isCorrect = true
        }
    }
    
    convenience init(question: String, answer1: String, answer2: String, answer3: String, answer4: String, correctAnswer: Int, image: PFFile){
        self.init(question: question, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, correctAnswer: correctAnswer)
        self.image = image
    }
}
