//
//  Question.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/10/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

class Question {
    
    var category: String?
    var difficulty: String?
    var question: String?
    
    init(category: String?, difficulty: String?, question: String?) {
        self.category = category
        self.difficulty = difficulty
        self.question = question
    }
}
