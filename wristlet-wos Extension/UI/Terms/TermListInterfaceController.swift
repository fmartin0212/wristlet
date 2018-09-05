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
    
    var quizletSet: QuizletSet?
    
    override func awake(withContext context: Any?) {
    
        guard let set = context as? QuizletSet else { return }
        self.quizletSet = set
        self.setTitle(set.title)
        configureTable()
    }
}

extension TermListInterfaceController {
    
    func configureTable() {
    
        guard let quizletSet = quizletSet else { return }
        
        table.setNumberOfRows(quizletSet.terms.count, withRowType: "termRow")
        
        for index in 0..<quizletSet.terms.count {
            guard let rowController = table.rowController(at: index) as? TitleRowController else { return }
            
            rowController.termLabel.setText(quizletSet.terms[index].term)
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        guard let quizletSet = quizletSet else { return nil }
        
        if segueIdentifier == "toTermDetailSegue" {
            let terms = quizletSet.terms
            let term = terms[rowIndex]
            
            return [terms, term, rowIndex]
        }
        return nil
    }
}

