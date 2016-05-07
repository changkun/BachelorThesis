//
//  InterfaceController.swift
//  1-Demo-Tap-Watch Extension
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    @IBOutlet var index: WKInterfaceLabel!
    @IBOutlet var indexStrength: WKInterfaceLabel!
    @IBOutlet var grab: WKInterfaceLabel!
    @IBOutlet var tap: WKInterfaceLabel!
    
    @IBOutlet private weak var countButton: WKInterfaceButton!
    @IBOutlet private weak var tapButton: WKInterfaceButton!
    
    var tapCounter: Int = 0
    let currentDevice: WKInterfaceDevice = WKInterfaceDevice.currentDevice()

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        tapButton.setBackgroundColor(UIColor.grayColor())
    }

    func tapGesture() {
        self.currentDevice.playHaptic(.Success)
        self.countButton.setTitle("\(tapCounter)")
        self.tapButton.setBackgroundColor(UIColor.blackColor())
    }
    func forceGesture() {
        self.currentDevice.playHaptic(.Click)
        self.countButton.setTitle("Force!")
        self.countButton.setBackgroundColor(UIColor.blackColor())
    }
    func cancelGesture() {
        self.countButton.setTitle("\(tapCounter)")
        self.tapButton.setBackgroundColor(UIColor.grayColor())
        self.countButton.setBackgroundColor(UIColor.darkGrayColor())
    }
    
    override func willActivate() {
        super.willActivate()
    }
    override func didDeactivate() {
        super.didDeactivate()
    }

}


extension InterfaceController: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        guard message["interact"] as? [String:String] != nil else {return}
        
        
        let interactiveMsg = message["interact"] as! [String : String]
        
        self.index.setText(interactiveMsg["pinchIndex"])
        self.indexStrength.setText(interactiveMsg["pinchStrength"])
        self.grab.setText(interactiveMsg["grabStrength"])
        self.tap.setText(interactiveMsg["gesture"])
        if interactiveMsg["gesture"] == "cancel" {
            cancelGesture()
            return
        }
        if interactiveMsg["gesture"] == "tap" {
            tapCounter += 1
            tapGesture()
        }
        if interactiveMsg["forceValue"] != "nil" {
            forceGesture()
        }
    }
}