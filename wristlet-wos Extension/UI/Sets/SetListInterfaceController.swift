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
    var quizletClass: QuizletClass?
    
    var userID: String?
    var accessToken: String?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setTitle(quizletClass?.name ?? "My Sets")
        
        if let userID = UserDefaults.standard.object(forKey: "userID") as? String,
            let accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String {
            self.userID = userID
            self.accessToken = accessToken
        } else {
            // Configure interface objects here.

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
