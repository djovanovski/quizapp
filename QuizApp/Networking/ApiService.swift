//
//  ApiService.swift
//  QuizApp
//
//  Created by Darko . Jovanovski on 1/11/18.
//  Copyright © 2018 Darko Jovanovski. All rights reserved.
//

import UIKit

let ELEMENTS_AMOUNT = 10
let QUIZ_TYPE = "boolean"

class APIService: NSObject {
    
    lazy var endPoint: String = {
        return "https://opentdb.com/api.php?amount=\(ELEMENTS_AMOUNT)&type=\(QUIZ_TYPE)"
    }()
    
    func getQuizQuestions(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "ERROR"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["results"] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "ERROR"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}
