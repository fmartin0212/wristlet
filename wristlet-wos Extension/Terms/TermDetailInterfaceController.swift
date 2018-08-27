//
//  TermDetailInterfaceController.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/21/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit
import WatchKit

class TermDetailInterfaceController: WKInterfaceController {

    var terms: [Term]?
    var term: Term?
    var rowIndex: Int?
    var front: Bool = true
    
    @IBOutlet var termDefLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        guard let context = context as? [Any],
            let terms = context[0] as? [Term],
            let term = context[1] as? Term,
            let rowIndex = context[2] as? Int
            else { return }
        
        self.terms = terms
        self.term = term
        self.rowIndex = rowIndex
        updateViews()
    }
    
    @IBAction func tapGestureRecognizerTapped(_ sender: Any) {
        flipCard()
    }
    
    @IBAction func previousCardTapped() {
        switchCard(direction: "previous")
    }
    
    @IBAction func nextCardTapped() {
        switchCard(direction: "next")
    }
}

extension TermDetailInterfaceController {
    
    func updateViews() {
        guard let term = term else { return }
        termDefLabel.setText(term.term)
    }
    
    func flipCard() {
        guard let term = term else { return }
        if front {
            termDefLabel.setText(term.definition)
            front = false
        } else {
            termDefLabel.setText(term.term)
            front = true
        }
    }
    
    func switchCard(direction: String) {
        guard let terms = terms,
        var rowIndex = rowIndex
            else { return }
        
        switch direction {
        case "previous":
            if rowIndex - 1 < 0 {
                return
            } else {
                rowIndex -= 1
                self.rowIndex = rowIndex
                self.term = terms[rowIndex]
                updateViews()
            }
        case "next":
            if rowIndex + 1 > terms.count - 1 {
                return
            } else {
                rowIndex += 1
                self.rowIndex = rowIndex
                self.term = terms[rowIndex]
                updateViews()
            }
        default:
            return
        }
    }
    
    func nextCard() {
        
        
    }
}
