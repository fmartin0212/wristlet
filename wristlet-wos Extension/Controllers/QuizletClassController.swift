//
//  QuizletClassController.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/28/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation

class QuizletClassController {
    
    // MARK: - Constants & Variables
    static let shared = QuizletClassController()
    let baseURL = URL(string: "https://api.quizlet.com/2.0")
    let quizletManager = QuizletManager()
    var quizletClasses = [QuizletClass]()
    
    func fetchAllClasses(completion: @escaping (Bool) -> Void) {
        guard let username = quizletManager.username,
            var baseURL = baseURL
        else { completion(false) ; return }
        
        baseURL.appendPathComponent("users")
        let parameters = [username, "classes"]
        
        quizletManager.fetch(from: baseURL, with: parameters) { (data) in
            guard let data = data else { completion(false) ; return }
            
            do {
                let quizletClasses = try JSONDecoder().decode([QuizletClass].self, from: data)
                self.quizletClasses = quizletClasses
                print(quizletClasses)
                completion(true)
                
            } catch let error {
                print("There was an error decoding sets in the QuizletClassController: \(error)")
                completion(false) ; return
            }
        }
    }
}
