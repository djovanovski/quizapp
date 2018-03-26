//
//  StandardQuestion.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/17/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

class StandardQuestion: Question {
    
    var isCorrect: Bool?
    
    init(category: String?, difficulty: String?, question: String?, isCorrect: Bool?) {
        self.isCorrect = isCorrect
        super.init(category: category, difficulty: difficulty, question: question)
    }
}
