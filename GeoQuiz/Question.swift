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
    var text: String = ""
    var isCorrect: Bool = false
}

class Question {
    var question: String
    var answers: [Answer] = [Answer(), Answer(), Answer(), Answer()]
    var image: PFFile! = nil
    var timer = NSTimer()
    var counter: Double = 10.0
    var decrementTime: Double = 0.1
    
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
        default:
            break
        }
        answers.shuffle()
    }
    
    convenience init(question: String, answer1: String, answer2: String, answer3: String, answer4: String, correctAnswer: Int, image: PFFile){
        self.init(question: question, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, correctAnswer: correctAnswer)
        self.image = image
    }
    
    func checkAnswer(guess: Int) -> Bool{
        return answers[guess - 1].isCorrect
    }
    
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(decrementTime, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: false)
    }
    
    func updateTimer(){
        counter -= decrementTime
        //add code to update label here
        if(counter <= 0){
            stopTimer()
            //add code to stop quiz
        }
    }
    
    func stopTimer(){
        timer.invalidate()
    }
}

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