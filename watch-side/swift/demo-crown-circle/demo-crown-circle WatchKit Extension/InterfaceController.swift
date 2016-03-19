//
//  InterfaceController.swift
//  demo-crown-circle WatchKit Extension
//
//  Created by 欧长坤 on 16/3/17.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    
    @IBOutlet var circleGroup: WKInterfaceGroup!
    @IBOutlet var picker: WKInterfacePicker!
    let watchDevice: WKInterfaceDevice = WKInterfaceDevice()
    var index: Int = 0

    @IBOutlet var x: WKInterfaceLabel!
    @IBOutlet var y: WKInterfaceLabel!
    @IBOutlet var z: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self // conforms to WCSessionDelegate
            session.activateSession()
        }
    
        var images: [UIImage]! = []
        var pickerItems: [WKPickerItem]! = []
        for (var i=0; i<=36; i++) {
            let name = "progress-\(i)"
            images.append(UIImage(named: name)!)
            
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(i)"
            pickerItems.append(pickerItem)
        }
        let circleImages = UIImage.animatedImageWithImages(images, duration: 0.0)
        circleGroup.setBackgroundImage(circleImages)
        picker.setCoordinatedAnimations([circleGroup])
        picker.setItems(pickerItems)
        

    }
    @IBAction func addIndex() {
        if index == 36 {
            index = 0
        } else {
            index += 1
        }
        watchDevice.playHaptic(WKHapticType.DirectionUp)
        picker.setSelectedItemIndex(index)
    }
    @IBAction func minusIndex() {
        if index == 0 {
            index = 36
        } else {
            index -= 1
        }
        watchDevice.playHaptic(WKHapticType.DirectionDown)
        picker.setSelectedItemIndex(index)
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

extension InterfaceController: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        guard message["up"] as? [String:String] != nil else {return}
        
//        let defaultAction = WKAlertAction(
//            title: "OK",
//            style: WKAlertActionStyle.Default) { () -> Void in
//        }
//        let actions = [defaultAction]
//        
//        presentAlertControllerWithTitle(
//            "Message Received",
//            message: "",
//            preferredStyle: WKAlertControllerStyle.Alert,
//            actions: actions)
        let content = message["up"] as! [String : String]

        x.setText(content["x"])
        y.setText(content["y"])
        z.setText(content["z"])
    }
}