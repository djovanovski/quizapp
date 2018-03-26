//
//  Constants.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/11/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

struct CoreDataModel {
    static let entityName = "Quiz"
    static let correct = "correct"
    static let incorrect = "incorrect"
    static let unnanswered = "unnanswered"
    static let type = "type"
    
}

struct SegueIDs {
    static let standardQuiz = "standardQuiz"
    static let personalityQuiz = "personalityQuiz"
    static let showStatistics = "showStatistics"
    static let finishQuiz = "finishQuiz"
}

func showAlertWith(title: String, buttonTitle: String, message: String, style: UIAlertControllerStyle = .alert, viewController: UIViewController) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    let action = UIAlertAction(title: buttonTitle, style: .default) { (action) in
        viewController.dismiss(animated: true, completion: nil)
    }
    alertController.addAction(action)
    viewController.present(alertController, animated: true, completion: nil)
}

let personalityDataSource = [
    [    "category":"Personality",
         "type":"multiple",
         "difficulty":"medium",
         "question":"Some question here",
         "correct_answer":"Answer 1",
         "incorrect_answers":[
            "Answer 1",
            "Answer 2",
            "Answer 3",
            "Answer 4"
        ],
         ],
    [    "category":"Personality",
         "type":"multiple",
         "difficulty":"medium",
         "question":"Some question here",
         "correct_answer":"Answer 1",
         "incorrect_answers":[
            "Answer 1",
            "Answer 2",
            "Answer 3",
            "Answer 4"
        ],
         ],
    [    "category":"Personality",
         "type":"multiple",
         "difficulty":"medium",
         "question":"Some question here",
         "correct_answer":"Answer 1",
         "incorrect_answers":[
            "Answer 1",
            "Answer 2",
            "Answer 3",
            "Answer 4"
        ],
         ],
    [    "category":"Personality",
         "type":"multiple",
         "difficulty":"medium",
         "question":"Some question here",
         "correct_answer":"Answer 1",
         "incorrect_answers":[
            "Answer 1",
            "Answer 2",
            "Answer 3",
            "Answer 4"
        ],
         ],
    
]
