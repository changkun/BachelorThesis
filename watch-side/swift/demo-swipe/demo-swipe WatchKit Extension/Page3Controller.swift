//
//  Page3Controller.swift
//  demo-swipe
//
//  Created by 欧长坤 on 16/3/19.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import Foundation
import WatchKit

class Page3Controller: WKInterfaceController {
    
    @IBOutlet var pageImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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