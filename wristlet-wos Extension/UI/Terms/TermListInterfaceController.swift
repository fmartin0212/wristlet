//
//  TermListInterfaceController.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/21/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit
import WatchKit

class TermListInterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    var set: CardSet?
    
    override func awake(withContext context: Any?) {
    
        guard let set = context as? CardSet else { return }
        self.set = set
        self.setTitle(set.title)
        configureTable()
    }
}

extension TermListInterfaceController {
    
    func configureTable() {
    
        guard let set = set else { return }
        
        table.setNumberOfRows(set.terms.count, withRowType: "termRowController")
        
        for index in 0..<set.terms.count {
            guard let rowController = table.rowController(at: index) as? TermListRowController else { return }
            
            rowController.termLabel.setText(set.terms[index].term)
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        guard let set = set else { return nil }
        
        if segueIdentifier == "toTermDetailSegue" {
            let terms = set.terms
            let term = terms[rowIndex]
            
            return [terms, term, rowIndex]
        }
        return nil
    }
}

