//
//  QuizletHelper.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/28/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation

class QuizletManager {

    // MARK: - Constants & Variables
    let watchConnectivityManager = WatchConnectivityManager()
    let baseURL = URL(string: "https://api.quizlet.com/2.0/users/")
    
    var username: String? {
        guard let username = UserDefaults.standard.object(forKey: "userID") as? String
            else { return nil }
        return username
    }
    
    var accessToken: String? {
        guard let accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String
            else { return nil }
        return accessToken
    }
}

extension QuizletManager {
    
    func getCredentials() {
        let message = ["getCredentials" : "getCredentials"]
        
        watchConnectivityManager.send(message: message) { (reply) in
            guard let reply = reply,
                let userID = reply["userID"] as? [String],
                let accessToken = reply["accessToken"] as? String
                else { return }
            
            UserDefaults.standard.setValue(userID, forKey: "userID")
            UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
            
        }
    }
    
    func fetch(_ object: String, searchParameters: [String], completion: @escaping (Data?) -> Void) {

        guard var url = baseURL,
            let username = username,
            let accessToken = accessToken
            else { completion(nil) ; return }
        
        url.appendPathComponent(username)
        searchParameters.forEach { url.appendPathComponent($0) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        NetworkController.fetch(with: urlRequest) { (data) in
            guard let data = data else { completion(nil) ; return }
            
            completion(data)
            
        }
    }
}






