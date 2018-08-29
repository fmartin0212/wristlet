//
//  ViewController.swift
//  wristlet
//
//  Created by Frank Martin Jr on 12/13/17.
//  Copyright © 2017 Frank Martin Jr. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {
    
    static var authRequestURL: URLRequest?

    @IBAction func authenticate(_ sender: Any) {
        NetworkController.requestAuthorization { (success) in
            // do something
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(accessTokenWasReceivedFrom(notification:)), name: accessTokenRecievedNotification, object: nil)
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        let accessToken: String? = UserDefaults.standard.value(forKey: "accessToken") as? String
        let userID: String? = UserDefaults.standard.value(forKey: "userID") as? String
        
        NetworkController.getUserInfo(userID: userID!, accessToken: accessToken!) { (arrayOfDicts) in
            print("arrayOfDicts: \(arrayOfDicts)")
        }
    }
    
    @IBAction func setsButtonTapped(_ sender: Any) {
       
    }
    
    @objc func accessTokenWasReceivedFrom(notification: Notification) {
        guard let accessToken = notification.userInfo?["accessToken"] as? String,
            let userID = notification.userInfo?["userID"] as? String
            else { return }
        print("Notification: \(accessToken)")
        print("UserID: \(userID)")
        
        UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
        UserDefaults.standard.setValue(userID, forKey: "userID")
    }
}

extension ViewController : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
     
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
     
    }
    
    func fileURL() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentDirectory = paths[0]
        
        let wristletLocation = "wristlet.json"
        
        let url = documentDirectory.appendingPathComponent(wristletLocation)
        print(url.absoluteString)
        
        return url
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        let string = "asdf"
        var dataPlaceholder = Data()
        do {
            let data = try JSONEncoder().encode(string)
            print(data)
            print("adsf")
//            replyHandler(data)
            dataPlaceholder = data
        } catch {
            print(error)
        }
        replyHandler(dataPlaceholder)
        
//        replyHandler(Data())
//        let accessToken: String? = UserDefaults.standard.value(forKey: "accessToken") as? String
//        let userID: String? = UserDefaults.standard.value(forKey: "userID") as? String
//        print("adsf")
//        NetworkController.getUserInfo2(userID: userID!, accessToken: accessToken!) { (sets) in
//            guard let sets = sets else { return }
//            print("test")
//            do {
//                let encoder = JSONEncoder()
//                let setsAsData = try encoder.encode(sets)
//                replyHandler(setsAsData)
//            } catch {
//                print(error)
//            }
        //
        //            replyHandler(Data())
        //        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        guard let userID = UserDefaults.standard.value(forKey: "userID"),
         let accessToken = UserDefaults.standard.value(forKey: "accessToken")
            else { replyHandler([:]) ; return }
        
        let reply = ["userID" : userID, "accessToken" : accessToken]
        
        replyHandler(reply)
      
    }
}



