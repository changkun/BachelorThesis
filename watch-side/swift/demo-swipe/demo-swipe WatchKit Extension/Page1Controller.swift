//
//  Page1Controller.swift
//  demo-swipe WatchKit Extension
//
//  Created by 欧长坤 on 16/3/19.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class Page1Controller: WKInterfaceController {
    
    @IBOutlet var pageImage: WKInterfaceImage!
    @IBOutlet var reciveMessage: WKInterfaceLabel?
    
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

extension Page1Controller: WCSessionDelegate {
    
    func sessionWatchStateDidChange(session: WCSession) {
        print(session)
        print("reachable:\(session.reachable)")
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        // 检查消息是否非法：同时为 yes
        let request = message["request"] as? [String:String]
        if request!["next"] == "yes" && request!["prev"] == "yes" {
            return
        }
        
        reciveMessage!.setText("reviced...")
        
        let defaultAction = WKAlertAction(title: "ok", style: .Default) { () -> Void in
        }
        let actions = [defaultAction]
        presentAlertControllerWithTitle("Message Recived", message: "\(request!["next"]),\(request!["prev"])", preferredStyle: .Alert, actions: actions)
    }
    
}
