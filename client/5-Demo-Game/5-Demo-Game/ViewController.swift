//
//  ViewController.swift
//  5-Demo-Game
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    @IBOutlet var pinchStrength: UILabel!
    
    var networkTask: Networking!
    var gesture: Gesture!
    var interaction: Interaction = Interaction()
    
    @IBOutlet var serverAlert: UILabel!
    @IBOutlet var ipContent: UITextField!
    @IBOutlet var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ipContent.delegate = self
    }

    @IBAction func connectServer(sender: AnyObject) {
        
        if ipContent.text != "" {
            
            networkTask = Networking(URL: ipContent.text!)
            
            let loading = MBProgressHUD.showHUDAddedTo(view, animated: true)
            loading.mode = .Indeterminate
            loading.label.text = "Connecting"
            
            if ( networkTask.isConnected() ) {
                serverAlert.text = "Game is running"
                connectButton.removeFromSuperview()
                NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.1), target: self, selector: #selector(ViewController.sendInteractionMsg), userInfo: nil, repeats: true)
                NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.1), target: networkTask, selector: #selector(Networking.connectServer), userInfo: nil, repeats: true)
                view.endEditing(true)
            } else {
                serverAlert.text = "Please input a correct IP Address!"
            }
            
            loading.hideAnimated(true)

        } else {
            serverAlert.text = "Please input IP Address!"
        }
        
    }
    func sendInteractionMsg() {
        if networkTask.gestureData != nil {
            gesture = Gesture(fromDictionary: networkTask.gestureData! )
        }
        if gesture != nil {
            
            pinchStrength.text = String(format: "Pinch Strength: %.2f", gesture.pinchStrength!)
            
            if WCSession.defaultSession().reachable {
                let interactiveContent: [String: String] = ["pinchStrength": String(gesture.pinchStrength)]
                interaction.update(gesture)
                let msg = ["interact": interactiveContent]
                
                WCSession.defaultSession().sendMessage(msg, replyHandler: { (_: [String : AnyObject]) in
                    print("Message Send Success.")
                    }, errorHandler: { (error) in
                        print(error)
                })
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        connectServer(textField)
        return true
    }
}
