//
//  WatchConnectivtyManager.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/28/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject {
    
    func send(message: [String : Any], completion: @escaping ([String : Any]?) -> Void) {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            session.sendMessage(message, replyHandler: { (reply) in
                completion(reply)
            }) { (error) in
                print(error)
                completion(nil)
            }
        }
    }
}

extension WatchConnectivityManager : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
