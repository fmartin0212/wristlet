//
//  CardSetController.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/28/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import WatchConnectivity

class QuizletSetController: NSObject {
    
    // MARK: - Constants & Variables
    static let shared = QuizletSetController()
    let quizletManager = QuizletManager()
    var quizletSets = [QuizletSet]()
    
    func fetchAllSets(completion: @escaping (Bool) -> Void) {
    
        let parameters = ["sets"]
        
        quizletManager.fetch(with: parameters) { (data) in
            
            guard let data = data else { completion(false) ; return }
            
            do {
                let sets = try JSONDecoder().decode([QuizletSet].self, from: data)
                self.quizletSets = sets
                completion(true)
            } catch {
                print("There was an error decoding sets in the QuizletSetController: \(error)")
                completion(false) ; return
            }
        }
    }
    
    func fetchSets(for quizletClass: QuizletClass, completion: @escaping ([QuizletSet]?) -> Void) {
        
        let parameters = ["classes", String(quizletClass.id), "sets"]
        
        quizletManager.fetch(with: parameters) { (data) in
            guard let data = data else { completion(nil) ; return }
            
            do {
                let quizletSetsForClass = try JSONDecoder().decode([QuizletSet].self, from: data)
                completion(quizletSetsForClass)
            } catch {
                print("There was an error decoding sets for QuizletClass in the QuizletSetController: \(error)")
                completion(nil) ; return
            }
        }
    }
}

extension QuizletSetController : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
