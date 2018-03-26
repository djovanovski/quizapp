//
//  PersonalityQuestion.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/17/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

class PersonalityQuestion: Question {
    
    var answers: [String]?
    var correctAnswer: String?
    
    init(category: String?, difficulty: String?, question: String?, answers: [String]?, correctAnswer: String?){
        self.answers = answers
        self.correctAnswer = correctAnswer
        super.init(category: category, difficulty: difficulty, question: question)
    }
}
