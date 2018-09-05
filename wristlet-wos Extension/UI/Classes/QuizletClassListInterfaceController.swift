//
//  QuizletClassListInterfaceController.swift
//  wristlet-wos Extension
//
//  Created by Frank Martin Jr on 8/30/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import WatchKit
import Foundation


class QuizletClassListInterfaceController: WKInterfaceController {
    
    // MARK: - Outlets
    @IBOutlet var table: WKInterfaceTable!
    
    // MARK: - Constants & Variables
    let quizletManager = QuizletManager()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if QuizletClassController.shared.quizletClasses.count == 0 {
            NotificationCenter.default.addObserver(self, selector: #selector(fetchAllClasses), name: Notifications.credentialsReceivedNotification.name, object: nil)
            
            table.setNumberOfRows(1, withRowType: "refreshRow")
            
            quizletManager.checkForCredentials()
        } else {
            configureTable()
        }
    }
}

extension QuizletClassListInterfaceController {
    
    func configureTable() {
        
        var rowTypes = [String]()
        
        rowTypes.append("refreshRow")
        for _ in QuizletClassController.shared.quizletClasses {
            rowTypes.append("classRow")
        }
        
        table.setRowTypes(rowTypes)
        
        for index in 1...rowTypes.count {
            guard let rowController = table.rowController(at: index) as? TitleRowController else { return }
            let quizletClass = QuizletClassController.shared.quizletClasses[index - 1]
            rowController.classNameLabel.setText(quizletClass.name)
        }
    }
    
    @objc func fetchAllClasses() {
        QuizletClassController.shared.fetchAllClasses(completion: { (success) in
            if success {
                self.configureTable()
            }
        })
        
    }
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        let quizletClass = QuizletClassController.shared.quizletClasses[rowIndex - 1]
        
        return quizletClass

    }
}
