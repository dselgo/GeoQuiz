//
//  Question.swift
//  GeoQuiz
//
//  Class for creating Question objects which hold the  question text, answers, image, and the correct answer identifier
//
//  Created by Danny on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import Foundation
import Parse

/**
 * Structure representing an answer. Contains the answer text and a boolean valus to tell if it is the correct answer
 */
struct Answer{
    var text: String = ""
    var isCorrect: Bool = false
}

class Question {
    var text: String
    var answers: [Answer] = [Answer(), Answer(), Answer(), Answer()]
    var image: PFFile! = nil
    
    /**
     * Initializer method for Question class.
     * Creates an array of 4 answers and sets one of them to true, then shuffles the array
     */
    init(text: String, answer1: String, answer2: String, answer3: String, answer4: String, correctAnswer: Int){
        self.text = text
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
        default:
            break
        }
        answers = answers.shuffle()
    }
    
    /** 
     * Convenience initializer method for questions with images
     */
    convenience init(text: String, answer1: String, answer2: String, answer3: String, answer4: String, correctAnswer: Int, image: PFFile){
        self.init(text: text, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, correctAnswer: correctAnswer)
        self.image = image
    }
}

/**
 * Extension method to the Array class
 * Allows shuffling of array elements so that the answers aren't in the same order each time
 */
extension Array {
    func shuffle() -> [T] {
        if count < 2 { return self }
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}