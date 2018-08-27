//
//  SetListInterfaceController.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/10/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class SetListInterfaceController: WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    var sets: [CardSet]?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setTitle("My Sets")
        
        if let sets = UserDefaults.standard.value(forKey: "sets") as? [CardSet] {
            self.sets = sets
            return
        } else {
        
        // Configure interface objects here.
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            let message = ["message" : "message"]
            session.sendMessage(message, replyHandler: { (reply) in
                print(reply)
                
                guard let userID = reply["userID"] as? String,
                    let accessToken = reply["accessToken"] as? String
                    else { return }
                
                NetworkController.fetchAllSets(userID: userID, accessToken: accessToken, completion: { (sets) in
                    guard let sets = sets else { return }
                    for set in sets {
                        print(set.title)
                    }
                    
                    self.sets = sets
                    
                    self.configureTable()
                })
                
            }) { (error) in
                print(error)
            }
        }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

extension SetListInterfaceController : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}

extension SetListInterfaceController {
    
    func configureTable() {
        guard let sets = sets else { return }
        
        var rowTypes = ["refreshRow"]
        for _ in 1...sets.count {
            rowTypes.append("setRow")
        }
        
        table.setRowTypes(rowTypes)
        
        for index in 0..<rowTypes.count {
            guard let rowController = table.rowController(at: index + 1) as? SetListRowController
                else { return }
            rowController.titleLabel.setText(sets[index].title)
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        
        if segueIdentifier == "toTermListSegue" {
            guard let sets = sets
                else { return nil }
            let set = sets[rowIndex - 1]
            
            return set
            
        }
        
        return nil
    }
}
