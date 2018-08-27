//
//  AppDelegate.swift
//  wristlet
//
//  Created by Frank Martin Jr on 12/13/17.
//  Copyright © 2017 Frank Martin Jr. All rights reserved.
//

import UIKit
import WatchConnectivity

let accessTokenRecievedNotification = Notification.Name("Access Token Received")

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    private var state: String?
    private var code: String?
    var authToken: String?
    var userID: String?
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
        
        if WCSession.isSupported() {
            let session = WCSession.default
//            session.delegate = self
            session.activate()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Quizlet passes token, pull out of URL
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return true }
        if let queryItems = components.queryItems {
            for queryItem in queryItems {
                if (queryItem.name == "state") {
                    state = queryItem.value
                }
                if (queryItem.name == "code") {
                    code = queryItem.value
                }
            }
        }
        guard let code = code else { return true }
        guard let state = state else { return true }
        print("STATE!!!: \(state)")
        print("CODE!!!: \(code)")
        
        NetworkController.fetchAuthToken(code: code) { (authTokenOptional, userID) in
            self.authToken = authTokenOptional
            self.userID = userID
            print("AUTH TOKEN!!: \(self.authToken)")
            
            DispatchQueue.main.async {
                guard let authToken = self.authToken,
                let userID = self.userID else { return }
                print(authToken)
                NotificationCenter.default.post(name: accessTokenRecievedNotification, object: self, userInfo: ["accessToken" : authToken, "userID" : userID])
//                print(NotificationCenter.userinf)
            }
            
        }
        
        return true
    }
}
