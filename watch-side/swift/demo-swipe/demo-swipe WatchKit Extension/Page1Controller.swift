//
//  Page1Controller.swift
//  demo-swipe WatchKit Extension
//
//  Created by 欧长坤 on 16/3/19.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import WatchKit
import Foundation


class Page1Controller: WKInterfaceController {

    @IBOutlet var page1Image: WKInterfaceImage!
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func nextController() {
        
    }

}
