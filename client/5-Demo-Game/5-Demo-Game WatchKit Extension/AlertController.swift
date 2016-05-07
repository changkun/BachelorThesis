//
//  AlertController.swift
//  5-Demo-Game
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import Foundation
import WatchKit

protocol AlertControllerDelegate {
    func alertControllerWillDismiss()
}

class AlertController: WKInterfaceController {
    @IBOutlet weak var alertLabel: WKInterfaceLabel!
    @IBOutlet weak var labelGroup: WKInterfaceGroup!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if context != nil {
            self.setTitle("Close")
            
            //set text of alert to whatever we're passed
            if let text = context!["text"] as? String {
                alertLabel.setText(text)
                
                //alerts are positive or negative; green or red
                let positive = context!["positive"] as? Bool
                
                if positive! {
                    labelGroup.setBackgroundColor(UIColor.redColor())
                } else {
                    labelGroup.setBackgroundColor(UIColor.greenColor())
                }
            }
            
            //get duration of alert showing, if passed, else default to 2
            let duration = context!["duration"] as? Double ?? 2 as Double
            
            //delay dismissing alert for [duration] seconds
            delay(duration) {
                let delegate = context!["delegate"] as? AlertControllerDelegate
                if delegate != nil {
                    delegate!.alertControllerWillDismiss()
                }
                
                self.dismissController()
            }
        }
    }
    
}