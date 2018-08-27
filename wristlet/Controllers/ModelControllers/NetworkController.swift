//
//  NetworkController.swift
//  wristlet
//
//  Created by Frank Martin Jr on 12/25/17.
//  Copyright © 2017 Frank Martin Jr. All rights reserved.
//

import UIKit

class NetworkController {
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    static func requestAuthorization(completion: @escaping ((Bool)-> Void)) {
        guard let url = URL(string: "https://quizlet.com/authorize") else { completion(false); return  }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let scopeQueryItem = URLQueryItem(name: "scope", value: "read")
        let clientIDQueryItem = URLQueryItem(name: "client_id", value: "PhqAKp7ppR")
        let responseTypeQueryItem = URLQueryItem(name: "response_type", value: "code")
        let stateQueryItem = URLQueryItem(name: "state", value: "o93dENhJq14n5D")
        let redirectURIQueryItem = URLQueryItem(name: "redirect_uri", value: "wristlet://after_oauth")
        components?.queryItems = [scopeQueryItem, clientIDQueryItem, responseTypeQueryItem, stateQueryItem, redirectURIQueryItem]
        
        let urlForRequest = components?.url
        
        guard let requestURL = urlForRequest else { completion(false); return }
        print(requestURL)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.Get.rawValue
        request.httpBody = nil
        
        UIApplication.shared.open(requestURL, options: [:], completionHandler: nil)
        completion(true)
    }

    

    static func fetchAuthToken(code: String, completion: @escaping ((String?, String?) -> Void)) {
        let baseURL = URL(string: "https://api.quizlet.com/oauth/token")
        guard let url = baseURL else { completion(nil, nil) ; return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let grantTypeQueryItem = URLQueryItem(name: "grant_type", value: "authorization_code")
        let codeQueryItem = URLQueryItem(name: "code", value: code)
        let redirectURIQueryItem = URLQueryItem(name: "redirect_uri", value: "wristlet://after_oauth")
        components?.queryItems = [grantTypeQueryItem, codeQueryItem, redirectURIQueryItem]
        
        guard let requestURL = components?.url else { completion(nil, nil) ; return }
        
        let clientID = "PhqAKp7ppR"
        let clientSecret = "NCwxBuvHMTm9m6axC2aGdE"
        let loginString = String(format: "%@:%@", clientID, clientSecret)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        print(base64LoginString)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, nil) ; return
            }
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                print(data)
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else { return }
                print(json.values)
                let accessToken = json["access_token"] as! String
                let userID = json["user_id"] as! String
                completion(accessToken, userID)
            }
            
        }
        dataTask.resume()
        
    }
    
    static func getUserInfo(userID: String, accessToken: String, completion: @escaping (([[String : Any]]?) -> Void)) {
        let baseURL = URL(string: "https://api.quizlet.com/2.0/users/\(userID)")
        guard var url = baseURL else { completion(nil) ; return }
        
        url.appendPathComponent("sets")
        print(url)
        
        var request = URLRequest(url: url)
        request.httpBody = nil
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(data)
            guard let data = data else { completion(nil) ; return }

            do {
                let topLevelArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : Any]]
                completion(topLevelArray)
                
            } catch {
                print(error)
            }
            completion(nil)
            
        }
        
        dataTask.resume()
    }
    
    static func getUserInfo2(userID: String, accessToken: String, completion: @escaping (([CardSet]?) -> Void)) {
        let baseURL = URL(string: "https://api.quizlet.com/2.0/users/\(userID)")
        guard var url = baseURL else { completion(nil) ; return }
        
        url.appendPathComponent("sets")
        print(url)
        //        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        //        let grantTypeQueryItem = URLQueryItem(name: "grant_type", value: "authorization_code")
        //        let codeQueryItem = URLQueryItem(name: "code", value: code)
        //        let redirectURIQueryItem = URLQueryItem(name: "redirect_uri", value: "wristlet://after_oauth")
        //        components?.queryItems = [grantTypeQueryItem, codeQueryItem, redirectURIQueryItem]
        
        //        guard let requestURL = components?.url else { completion(nil) ; return }
        
        var request = URLRequest(url: url)
        request.httpBody = nil
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(nil) ; return }
            guard let sets = try? JSONDecoder().decode([CardSet].self, from: data) else { completion(nil) ; return }
            print(sets)
            for set in sets {
                print(set.title)
            }
            completion(sets)
        
    }
        dataTask.resume()
    }
    
    static func getUsersClasses(userID: String, completion: @escaping (Bool) -> Void) {
        guard var baseURL = URL(string: "https://api.quizlet.com/2.0/users") else { completion(false) ; return }
        baseURL.appendPathComponent(userID)
        baseURL.appendPathComponent("classes")
        
        
        
    }
}
