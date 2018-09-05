//
//  WatchConnectivtyManager.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/28/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol WatchConnectivityManagerDelegate: class {
    func handle(reply: [String : Any])
}


class WatchConnectivityManager: NSObject {
    
    var message: [String : Any]?
    weak var delegate: WatchConnectivityManagerDelegate?
    
    func send(message: [String : Any]) {
        self.message = message
        
        if WCSession.isSupported() {
        let session = WCSession.default
        session.delegate = self
        session.activate()
        
        }
    }
}


extension WatchConnectivityManager : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard let message = message else { return }
        
        session.sendMessage(message, replyHandler: { (reply) in
            self.delegate?.handle(reply: reply)
        }) { (error) in
            print(error)
        }
    }
}
