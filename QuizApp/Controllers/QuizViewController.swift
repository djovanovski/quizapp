//
//  ViewController.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/10/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit
import CoreData

let STANDARD_TYPE = "Standard"
let PERSONALITY_TYPE = "Personality"

enum QuizType {
    case Standard
    case Personality
}

class QuizViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,StandardQuestionCollectionViewCellDelegate,PersonalityQuestionCollectionViewCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isStandard: Bool = false
    
    private var questionsDataSource = [AnyObject]()
    

    private var statistics:Statistic?
    private var collectionViewLayout = UICollectionViewFlowLayout()

    //MARK: - UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem  =  UIBarButtonItem(image: UIImage(named: "home"), style: .plain, target: self, action: #selector(homeClicked))
        self.questionsDataSource = isStandard ? [StandardQuestion]() : [PersonalityQuestion]()
        
        self.setupCollectionViewLayout()
        self.apiCall()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.setupCollectionViewLayout()
        self.collectionView.reloadData()
    }
    
    
    //MARK: - CollectionViewDelegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isStandard {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardQuestionCollectionViewCell.reuseIdentifier, for: indexPath) as! StandardQuestionCollectionViewCell
            if let question = questionsDataSource[indexPath.row] as? StandardQuestion {
                cell.populateWith(question: question)
                cell.indexPath = indexPath
                cell.standardQuestionCollectionViewCellDelegate = self
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalityQuestionCollectionViewCell.reuseIdentifier, for: indexPath) as! PersonalityQuestionCollectionViewCell
            if let question = questionsDataSource[indexPath.row] as? PersonalityQuestion {
                cell.populateWith(question: question)
                cell.indexPath = indexPath
                cell.populateButtonsWith(personalityQuestion: question)
                cell.personalityQuestionCollectionViewCellDelegate = self
            }
            
            return cell
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        return size
    }
    
    
    //MARK - StandardQuestionCollectionViewCellDelegate
    func questionAnswered(value: Bool, indexPath: IndexPath?) {
        
        if let indexPath = indexPath, let dataSource = questionsDataSource[indexPath.row] as? StandardQuestion {
            let questionAnswered = dataSource
            let userAnswered = value
            let answer = questionAnswered.isCorrect
            
            
            func handleStandardQuizStatisticsWithAnswer(value: Bool, type: String) {
                switch value {
                case true:
                    statistics?.correct +=  1
                    statistics?.unnanswered -= 1
                    statistics?.type = type
                case false:
                    statistics?.incorrect +=  1
                    statistics?.unnanswered -= 1
                    statistics?.type = type
                }
            }
            
            
            handleStandardQuizStatisticsWithAnswer(value: (userAnswered == answer),type: STANDARD_TYPE)

            if indexPath.row + 1 != questionsDataSource.count {
                self.questionAnsweredAt(indexPath: indexPath)
            }
            else {
                self.performSegue(withIdentifier: SegueIDs.finishQuiz, sender: self)
            }
        }
    }
    //TODO: - The ideal is to make 1 delegate for both cells, it can be done with more time and thinking about the bigger picture(what the will do and how will we handle perosnality quizz)
    //MARK - PersonalityQuestionCollectionViewCellDelegate
    func questionAnswered(value: String, indexPath: IndexPath?) {
        if let indexPath = indexPath, let dataSource = questionsDataSource[indexPath.row] as? PersonalityQuestion, let answers = dataSource.answers, let correctAnswer = dataSource.correctAnswer {


            func handlePersonalityStatisticsWithAnswer(value: String, type: String) {
                switch value == correctAnswer  {
                case true:
                    statistics?.correct +=  1
                    statistics?.unnanswered -= 1
                    statistics?.type = type
                case false:
                    statistics?.incorrect +=  1
                    statistics?.unnanswered -= 1
                    statistics?.type = type
                    
                }
            }
            handlePersonalityStatisticsWithAnswer(value: correctAnswer, type: PERSONALITY_TYPE)
            
            if indexPath.row + 1 != questionsDataSource.count {
                self.questionAnsweredAt(indexPath: indexPath)
            }
            else {
                self.performSegue(withIdentifier: SegueIDs.finishQuiz, sender: self)

            }
        }
    }

    

    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == SegueIDs.finishQuiz){
            if let vc = segue.destination as? ScoreViewController {
                self.save()
                vc.statistic = self.statistics
            }
        }
    }
    
    //MARK: - Parsing Data
    private func apiCall() {
        if isStandard {
            self.activityIndicator.startAnimating()
            APIService().getQuizQuestions { (result) in
                switch result {
                case .Success(let data):
                    self.parseDataWith(array: data, quizType: QuizType.Standard)
                case .Error(let message):
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.stopAnimating()
                        if let vc = self {
                            showAlertWith(title: "Error", buttonTitle: "OK", message: message, style: .alert, viewController: vc)
                        }
                    }
                }
            }
        }
        else{
            parseDataWith(array: personalityDataSource as [[String : AnyObject]], quizType: QuizType.Personality)
        }
    }
    private func parseDataWith(array:[[String: AnyObject]], quizType: QuizType) {
        var tmpDataSource = [AnyObject]()
        
        tmpDataSource = quizType == .Standard ? [StandardQuestion]() : [PersonalityQuestion]()
        let type = quizType == .Standard ? STANDARD_TYPE : PERSONALITY_TYPE
        for item in array {
            let category = item["category"] as? String
            let difficulty = item["difficulty"] as? String
            let question = item["question"] as? String
            let correctAnswer = item["correct_answer"] as? String
            let isCorrect = (correctAnswer == "True") ? true : false
            let answers = item["incorrect_answers"] as? [String]

            if quizType == .Standard {
                tmpDataSource.append(StandardQuestion(category: category, difficulty: difficulty, question: question, isCorrect: isCorrect))
            }
            else {
                tmpDataSource.append(PersonalityQuestion(category: category, difficulty: difficulty, question: question, answers: answers, correctAnswer: correctAnswer))
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.navigationItem.title = "Question 1"
            self?.questionsDataSource = tmpDataSource
            self?.statistics = Statistic(correct: 0, incorrect: 0, unnanswered: tmpDataSource.count, type: type)
            self?.collectionView.reloadData()
        }
        
    }
    
    //MARK: - CoreData
    func save() {
        let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: CoreDataModel.entityName, in: managedContext) {
            let quiz = NSManagedObject(entity: entity, insertInto: managedContext)
            quiz.setValue(statistics?.correct, forKeyPath: CoreDataModel.correct)
            quiz.setValue(statistics?.incorrect, forKeyPath: CoreDataModel.incorrect)
            quiz.setValue(statistics?.unnanswered, forKeyPath: CoreDataModel.unnanswered)
            quiz.setValue(statistics?.type, forKeyPath: CoreDataModel.type)

            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    //MARK: - Private functions
    private func questionAnsweredAt(indexPath: IndexPath) {
        self.collectionView.scrollToItem(at: IndexPath(item: indexPath.row + 1, section: indexPath.section), at: .centeredHorizontally, animated: true)
        self.navigationItem.title = "Question \(indexPath.row + 2)"
    }
    private func setupCollectionViewLayout() {
        self.collectionView.register(UINib.init(nibName: StandardQuestionCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: StandardQuestionCollectionViewCell.reuseIdentifier)
        self.collectionView.register(UINib.init(nibName: PersonalityQuestionCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PersonalityQuestionCollectionViewCell.reuseIdentifier)
        self.collectionViewLayout.scrollDirection = .horizontal
        //TODO: - need to fix this ui // portrait-landscape navigationBar.height is not the same
        self.collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        self.collectionView.collectionViewLayout = collectionViewLayout
    }
    
    @objc private func homeClicked() {
        self.navigationController?.popViewController(animated: true)
    }
}

