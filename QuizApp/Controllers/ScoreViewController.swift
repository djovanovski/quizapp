//
//  ScoreViewController.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/10/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var lblCorrect: UILabel!
    @IBOutlet weak var lblIncorrect: UILabel!
    @IBOutlet weak var lblUnnanswered: UILabel!
    @IBOutlet weak var lblType: UILabel!

    weak var statistic: Statistic?
    
    //MARK: - UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IBActions
    @IBAction func homepageClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    //MARK: - PrivateFunctions
    func setupUI() {
        //TODO: - Need to show different view based from the type of the quiz, if its personality we need to use formula and present the personality from the quiz
        lblCorrect.text = "\(statistic?.correct ?? 0)"
        lblIncorrect.text = "\(statistic?.incorrect ?? 0)"
        lblUnnanswered.text = "\(statistic?.unnanswered ?? 0)"
        lblType.text = statistic?.type ?? "unknown"
        
    }
}
