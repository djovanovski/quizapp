//
//  Statistic.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/10/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

class Statistic {
    
    var correct: Int
    var incorrect: Int
    var unnanswered: Int
    var type: String
    
    init(correct: Int, incorrect: Int, unnanswered: Int, type:String) {
        self.correct = correct
        self.incorrect = incorrect
        self.unnanswered = unnanswered
        self.type = type
    }
}
