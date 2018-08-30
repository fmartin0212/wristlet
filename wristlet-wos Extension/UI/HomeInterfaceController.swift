//
//  HomeInterfaceController.swift
//  wristlet
//
//  Created by Frank Martin Jr on 8/10/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import WatchKit
import Foundation

class HomeInterfaceController: WKInterfaceController {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.setTitle("Home")
    
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


