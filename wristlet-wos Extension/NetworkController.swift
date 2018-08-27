//
//  NetworkController.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/21/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation

class NetworkController {
    
    static func fetchAllSets(userID: String, accessToken: String, completion: @escaping ([CardSet]?) -> Void) {
        
        let baseURL = URL(string: "https://api.quizlet.com/2.0/users/\(userID)")
        guard var url = baseURL else { completion(nil) ; return }
        
        url.appendPathComponent("sets")
        print(url)
        
        var request = URLRequest(url: url)
        request.httpBody = nil
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                let sets = try? JSONDecoder().decode([CardSet].self, from: data) else { completion(nil) ; return }
            
            completion(sets)
        }
        
        dataTask.resume()
    }
    
    static func fetchAllClasses(username: String, accessToken: String, completion: @escaping ([Class]?) -> Void) {
        
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

