//
//  PersonalityQuestionCollectionViewCell.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/17/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

protocol PersonalityQuestionCollectionViewCellDelegate:class {
    func questionAnswered(value: String, indexPath: IndexPath?)
}

class PersonalityQuestionCollectionViewCell: QuestionCell {

    @IBOutlet var btnCollection: [UIButton]!
    
    weak var personalityQuestionCollectionViewCellDelegate: PersonalityQuestionCollectionViewCellDelegate?
    
    static var reuseIdentifier: String {
        return "PersonalityQuestionCollectionViewCell"
    }
    
    func populateWith(question: PersonalityQuestion) {
        super.populateWith(question: question)
    }

    func populateButtonsWith(personalityQuestion: PersonalityQuestion) {
        if let answers = personalityQuestion.answers {
            for i in 0..<answers.count {
                let answer = answers[i]
                let button  = btnCollection[i]
                button.setTitle(answer, for: .normal)
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func buttonClicked(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            personalityQuestionCollectionViewCellDelegate?.questionAnswered(value: title, indexPath: self.indexPath)
        }

    }
}
