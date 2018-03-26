//
//  QuestionCell.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/10/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

class QuestionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblDifficulty: UILabel!
 
    var indexPath: IndexPath?
    
    
    func populateWith(question: Question) {
        self.lblCategory.text = question.category
        self.lblDifficulty.text = question.difficulty
        self.lblQuestion.text = question.question
        self.lblDifficulty.backgroundColor = setupLabelBackground(difficulty: question.difficulty)
    }
    
    //MARK: - Private
    func setupLabelBackground(difficulty: String?) -> UIColor {
        if let difficulty = difficulty {
            switch difficulty {
            case "easy":
                return UIColor.green
            case "medium":
                return UIColor.yellow
            case "hard":
                return UIColor.red
            default:
                return UIColor.clear
            }
        }
        return UIColor.clear
    }
}
