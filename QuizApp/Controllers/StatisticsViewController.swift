//
//  StatisticsViewController.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/11/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit
import CoreData

class StatisticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tblStatistics: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var quiz: [NSManagedObject] = []
    private var dataSource = Dictionary<Int,Int>()
    private var managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Quiz> = {
        
        let fetchRequest: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "type", cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    //MARK: - UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCoreData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: UITableViewDelegates
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { fatalError("Unexpected Section") }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { fatalError("Unexpected Section") }
        return sectionInfo.name
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = fetchedResultsController.object(at: indexPath)
        let correct = object.correct
        if object.type == STANDARD_TYPE {
            cell.textLabel?.text = " \(STANDARD_TYPE) Quiz with \(correct) correct answers."
        }
//        else {
//            cell.textLabel?.text = " \(PERSONALITY_TYPE) Quiz you are an (percentage and result)"
//
//        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    //MARK: - Private
    func fetchCoreData() {
        self.activityIndicator.startAnimating()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataModel.entityName)
        
        do {
            self.quiz = try managedContext.fetch(fetchRequest)
            
            self.extractDBtoDataSource()
        } catch let error as NSError {
            self.activityIndicator.stopAnimating()
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func extractDBtoDataSource() {
        var tmpDict = Dictionary<Int,Int>()
        
        for object in quiz {
            if let correct = object.value(forKeyPath: CoreDataModel.correct) as? Int {
                if tmpDict.isEmpty {
                    tmpDict.updateValue(1, forKey: correct)
                }
                else{
                    let value = tmpDict[correct] ?? 0
                    tmpDict.updateValue(value + 1, forKey: correct)
                }
            }
        }
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            self.activityIndicator.stopAnimating()
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.dataSource = tmpDict
        self.activityIndicator.stopAnimating()
        self.tblStatistics.reloadData()
    }
}
