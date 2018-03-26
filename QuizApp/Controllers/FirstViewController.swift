//
//  FirstViewController.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/10/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    //MARK: - UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIDs.standardQuiz {
            if let vc = segue.destination as? QuizViewController {
                vc.isStandard = true
            }
        }
        else if segue.identifier == SegueIDs.personalityQuiz {
            if let vc = segue.destination as? QuizViewController {
                vc.isStandard = false
            }
        }
    }
 
}
