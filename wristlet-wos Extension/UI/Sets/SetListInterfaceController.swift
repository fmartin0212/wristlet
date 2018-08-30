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
    
    // MARK: - Outlets
    @IBOutlet var table: WKInterfaceTable!
    
    // MARK: - Constants & Variables
    let quizletManager = QuizletManager()
    var quizletClass: QuizletClass?
    var quizletSetsForClass = [QuizletSet]()
    var userID: String?
    var accessToken: String?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.setTitle(quizletClass?.name ?? "My Sets")
        table.setNumberOfRows(1, withRowType: "refreshRow")
        
        quizletManager.checkForCredentials { (success) in
            if success {
                if let quizletClass = self.quizletClass {
                    QuizletSetController.shared.fetchSets(for: quizletClass, completion: { (quizletSetsForClass) in
                        DispatchQueue.main.async {
                            guard let quizletSetsForClass = quizletSetsForClass else { return }
                            self.quizletSetsForClass = quizletSetsForClass
                            self.configureTable()
                        }
                    })
                } else {
                    if QuizletSetController.shared.quizletSets.count == 0 {
                        QuizletSetController.shared.fetchAllSets(completion: { (success) in
                            if success {
                                DispatchQueue.main.async {
                                    self.configureTable()
                                }
                            }
                        })
                    }
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

extension SetListInterfaceController {
    
    func configureTable() {
        var dataSource = [QuizletSet]()
        if quizletClass == nil {
            dataSource = QuizletSetController.shared.quizletSets
        } else {
            dataSource = quizletSetsForClass
        }
        
        var rowTypes = ["refreshRow"]
        for _ in 1...dataSource.count {
            rowTypes.append("setRow")
        }
        
        table.setRowTypes(rowTypes)
        
        for index in 0..<rowTypes.count {
            guard let rowController = table.rowController(at: index + 1) as? TitleRowController
                else { return }
            rowController.setTitleLabel.setText(dataSource[index].title)
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        
        if segueIdentifier == "toTermListSegue" {
            let quizletSet = QuizletSetController.shared.quizletSets[rowIndex - 1]
            
            return quizletSet
        }
        return nil
    }
}
