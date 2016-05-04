//
//  ViewController.swift
//  1-Demo-Tap
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    @IBOutlet var pinchIndex: UILabel!
    @IBOutlet var pinchStrength: UILabel!
    @IBOutlet var grabStrength: UILabel!
    @IBOutlet var forceValue: UILabel!
    
    enum CompleteStatu {
        case Finish
        case Notyet
    }
    
    let url = NSURL(string: "http://192.168.1.102:10086")!
    let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
    var task: NSURLSessionDataTask?
    var session: NSURLSession!
    
    var gesture: Gesture!
    var interaction: Interaction = Interaction()
    
    var msgComplete: CompleteStatu = .Finish
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = NSURLSession(configuration: conf)
        if session == nil {
            print("Network session create failed.")
        }
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.1), target: self, selector: #selector(ViewController.sendInteractionMsg), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.1), target: self, selector: #selector(ViewController.connectServer), userInfo: nil, repeats: true)
    }
    
    func sendInteractionMsg() {
        if self.gesture != nil {
            switch self.gesture.pinchIndex {
            case 1:
                self.pinchIndex.text = String("Pinch Finger: Index Finger")
            case 2:
                self.pinchIndex.text = String("Pinch Finger: Middle Finger")
            case 3:
                self.pinchIndex.text = String("Pinch Finger: Ring Finger")
            case 4:
                self.pinchIndex.text = String("Pinch Finger: Pinky Finger")
            default:
                self.pinchIndex.text = String("Pinch Finger: No Finger")
            }
            
            self.pinchStrength.text = String(format: "Pinch Strength: %.2f", self.gesture.pinchStrength!)
            self.grabStrength.text = String(format: "Grab Strength: %.2f", self.gesture.grabStrength!)
            self.forceValue.text = String(format: "Force Value: %.2f", self.gesture.forceValue!)
            
            if WCSession.defaultSession().reachable {
                var interactiveContent: [String: String] = ["pinchIndex": String(self.gesture.pinchIndex), "pinchStrength": String(self.gesture.pinchStrength), "grabStrength": String(self.gesture.grabStrength) ]
                self.interaction.update(self.gesture)
                if self.interaction.isTaped() {
                    interactiveContent["gesture"] = "tap"
                } else {
                    interactiveContent["gesture"] = "nil"
                }
                
                if self.interaction.isCancelPinch() {
                    interactiveContent["gesture"] = "cancel"
                }
                
                if self.interaction.isForceTaped() {
                    interactiveContent["forceValue"] = "force"
                } else {
                    interactiveContent["forceValue"] = "nil"
                }
                
                let msg = ["interact": interactiveContent]
                
                WCSession.defaultSession().sendMessage(msg, replyHandler: { (_: [String : AnyObject]) in
                    print("Message Send Success.")
                    }, errorHandler: { (error) in
                        print(error)
                })
            }
        }
    }
    
    func connectServer() {
        if msgComplete == .Notyet {
            return
        }
        msgComplete = .Notyet
        task = session.dataTaskWithURL(url, completionHandler: {
            (data, res, error) -> Void in
            if let err = error {
                print("dataTaskWithURL fail: \(err.debugDescription)")
                return
            }
            if let d = data {
                if let jsonObj = try? NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                    self.gesture = Gesture(fromDictionary: jsonObj!)
                }
                self.msgComplete = .Finish
            }
        })
        task!.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

