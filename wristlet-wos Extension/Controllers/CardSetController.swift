//
//  CardSetController.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/28/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation
import WatchConnectivity

class CardSetController: NSObject {
    
    static let shared = CardSetController()
    
    var sets = [CardSet]()
    
    
    
    
    func fetchAllSets(completion: @escaping (Bool) -> Void) {
    
        
//                
//                guard let userID = reply["userID"] as? String,
//                    let accessToken = reply["accessToken"] as? String
//                    else { return }
//                
//                NetworkController.fetchAllSets(userID: userID, accessToken: accessToken, completion: { (sets) in
//                    guard let sets = sets else { return }
//                    
//                    self.sets = sets
//                    
//                })
//            })
//        }
    }
}

extension CardSetController : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
