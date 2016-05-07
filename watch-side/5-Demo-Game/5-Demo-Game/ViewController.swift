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
    
    var networkTask: Networking = Networking()
    var gesture: Gesture!
    var interaction: Interaction = Interaction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.1), target: self, selector: #selector(ViewController.sendInteractionMsg), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.1), target: networkTask, selector: #selector(Networking.connectServer), userInfo: nil, repeats: true)
    }

    func sendInteractionMsg() {
        if let d = networkTask.gestureData {
            gesture = Gesture(fromDictionary: d)
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
}

