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
    
    init() {
        watchConnectivityManager.delegate = self
    }
}


extension QuizletManager {
    
    func checkForCredentials() {
        if let _ = username,
            let _ = accessToken {
            NotificationCenter.default.post(Notifications.credentialsReceivedNotification)
            return
        } else {
            getCredentials()
        }
    }
    
    func getCredentials() {
        let message = ["getCredentials" : "getCredentials"]
        
        watchConnectivityManager.send(message: message)
    }
    
    
    func fetch(from baseURL: URL, with parameters: [String], completion: @escaping (Data?) -> Void) {
        
            guard let accessToken = accessToken
            else { completion(nil) ; return }
        
        var url = baseURL
        parameters.forEach { url.appendPathComponent($0) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        NetworkController.fetch(with: urlRequest) { (data) in
            guard let data = data else { completion(nil) ; return }
            
            completion(data)
            
        }
    }
}

extension QuizletManager : WatchConnectivityManagerDelegate {
   
    func handle(reply: [String : Any]) {
        guard let userID = reply["userID"] as? String,
            let accessToken = reply["accessToken"] as? String
            else { return }
        
        UserDefaults.standard.setValue(userID, forKey: "userID")
        UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
        
        NotificationCenter.default.post(Notifications.credentialsReceivedNotification)
    
    }
}






