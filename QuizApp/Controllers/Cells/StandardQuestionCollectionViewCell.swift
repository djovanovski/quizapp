//
//  StandardQuestionCollectionViewCell.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/17/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

let TRUE_BUTTON_TITLE = "True"
let FALSE_BUTTON_TITLE = "False"

protocol StandardQuestionCollectionViewCellDelegate:class {
    func questionAnswered(value: Bool, indexPath: IndexPath?)
}

class StandardQuestionCollectionViewCell: QuestionCell {

    @IBOutlet weak var btnTrue: UIButton!
    @IBOutlet weak var btnFalse: UIButton!
    
    weak var standardQuestionCollectionViewCellDelegate: StandardQuestionCollectionViewCellDelegate?

    static var reuseIdentifier: String {
        return "StandardQuestionCollectionViewCell"
    }
    
    override func populateWith(question: Question) {
        super.populateWith(question: question)
        btnTrue.setTitle(TRUE_BUTTON_TITLE, for: .normal)
        btnFalse.setTitle(FALSE_BUTTON_TITLE, for: .normal)
    }

    
    //MARK: - IBActions
    @IBAction func buttonClicked(_ sender: UIButton) {
        switch sender.title(for: .normal) {
        case FALSE_BUTTON_TITLE?:
            standardQuestionCollectionViewCellDelegate?.questionAnswered(value: false, indexPath: self.indexPath)
        case TRUE_BUTTON_TITLE?:
            standardQuestionCollectionViewCellDelegate?.questionAnswered(value: true, indexPath: self.indexPath)
        default:
            return
        }
    }
    

    
}
