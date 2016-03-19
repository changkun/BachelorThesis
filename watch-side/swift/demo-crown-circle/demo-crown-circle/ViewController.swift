//
//  ViewController.swift
//  demo-crown-circle
//
//  Created by 欧长坤 on 16/3/17.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreMotion

class ViewController: UIViewController {

    let motionManager = CMMotionManager()
    
    @IBOutlet var x: UILabel!
    @IBOutlet var y: UILabel!
    @IBOutlet var z: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let handler:CMGyroHandler = {(data: CMGyroData?, error: NSError?) -> Void in
            self.x.text = String(format: "%.2f", data!.rotationRate.x)
            self.y.text = String(format: "%.2f", data!.rotationRate.y)
            self.z.text = String(format: "%.2f", data!.rotationRate.z)
        }
        
        if motionManager.gyroAvailable {
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
        }
        else {
            x.text = "not available"
            y.text = "not available"
            z.text = "not available"
        }
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.1), target: self, selector: "updateMessage", userInfo: nil, repeats: true)
    }
    
    func updateMessage() {
        
        if WCSession.defaultSession().reachable {
            let content:[String:String] = ["x":x.text!, "y":y.text!, "z":z.text!]
            let message = ["up": content]
            WCSession.defaultSession().sendMessage(
                message, replyHandler: { (replyMessage) -> Void in
                    print("send success..")
                }) { (error) -> Void in
                    print(error)
            }
        }
        
    }

    @IBAction func clickSend(sender: AnyObject) {
        
        if !WCSession.defaultSession().reachable {
        
            let alert = UIAlertController(title: "Failed to send", message: "Watch is not reachable", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let content:[String:String] = ["x":x.text!, "y":y.text!, "z":z.text!]
        let message = ["up": content]
        WCSession.defaultSession().sendMessage(
            message, replyHandler: { (replyMessage) -> Void in
                print("send success..")
            }) { (error) -> Void in
                print(error)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

