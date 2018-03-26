//
//  Quiz+CoreDataProperties.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/17/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//
//

import Foundation
import CoreData


extension Quiz {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quiz> {
        return NSFetchRequest<Quiz>(entityName: "Quiz")
    }

    @NSManaged public var correct: Int16
    @NSManaged public var incorrect: Int16
    @NSManaged public var unnanswered: Int16
    @NSManaged public var type: String

    
}
