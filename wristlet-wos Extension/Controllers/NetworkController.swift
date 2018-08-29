//
//  NetworkController.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/21/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation

class NetworkController {
    
    static func fetch(with urlRequest: URLRequest, completion: @escaping (Data?) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            if let error = error {
                print("There was an error performing a fetch in the NetworkController")
                completion(nil) ; return
            }
            
            guard let data = data else { completion(nil) ; return }
            completion(data)
        }
        
        dataTask.resume()
    }
    
    static func fetchAllClasses(username: String, accessToken: String, completion: @escaping ([QuizletClass]?) -> Void) {
        
        guard var baseURL = URL(string: "https://api.quizlet.com/2.0/users") else { completion(nil) ; return }
        
        baseURL.appendPathComponent(username)
        baseURL.appendPathComponent("classes")
        
        var request = URLRequest(url: baseURL)
        request.httpBody = nil
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("There was an error obtaining the user's classes: \(error)")
                    completion(nil)
                    return
            }
            
            guard let data = data else { completion(nil) ; return }
            do {
                let topLevelClassDictionary = try JSONDecoder().decode(TopLevelClassDictionary.self, from: data)
                completion(topLevelClassDictionary.classes)
            } catch {
                print(error)
                completion(nil)
                return
            }
        }
        dataTask.resume()
    }
}

