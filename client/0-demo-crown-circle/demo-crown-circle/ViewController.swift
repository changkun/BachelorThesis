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
    
    @IBOutlet var PinchFinger: UILabel!
    @IBOutlet var PinchStrength: UILabel!
    @IBOutlet var GrabStrength: UILabel!
    
    let url = NSURL(string: "http://192.168.1.100:10086/")!
    let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
    var task: NSURLSessionDataTask?
    var session: NSURLSession!
    
    var crownGesture: CrownGesture!
    var completeFlag: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        session = NSURLSession(configuration: conf)
        if session == nil {
            print("network session fail")
            return
        }
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.1), target: self, selector: #selector(ViewController.updateMessage), userInfo: nil, repeats: true)
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.05), target: self, selector: #selector(ViewController.connectServer), userInfo: nil, repeats: true)
        
    }
    
    func updateMessage() {
        if self.crownGesture != nil {
            self.PinchFinger.text = String(format: "Finger: %.2f", self.crownGesture.pinchIndex!)
            self.PinchStrength.text = String(format: "PinchStrength: %.2f", self.crownGesture.pinchStrength!)
            self.GrabStrength.text = String(format: "GrabStrength: %.2f", self.crownGesture.grabStrength!)
        }
        
        if WCSession.defaultSession().reachable {
            let content:[String:String] = ["x":PinchFinger.text!, "y":PinchStrength.text!, "z":GrabStrength.text!]
            let message = ["up": content]
            var value = (content["y"]! as NSString).doubleValue
            print("\(content["y"]!) and \(value)")
            value = value * 36.0
            print("\(value)")
            let itemIndex = Int(value)
            print("\(itemIndex)")
            
            WCSession.defaultSession().sendMessage(
                message, replyHandler: { (replyMessage) -> Void in
                    print("send success..")
                }) { (error) -> Void in
                    print(error)
            }
        }
        
    }

    func connectServer() {
        if completeFlag == 0 {
            return
        }
        task = session.dataTaskWithURL(url, completionHandler: { (data, res, error) -> Void in
            if let e = error {
                print("dataTaskWithURL fail: \(e.debugDescription)")
                return
            }
            if let d = data {
//                print("\(NSString(data: d, encoding: NSUTF8StringEncoding))")
                
                if let jsonObj = try? NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                   self.crownGesture = CrownGesture(fromDictionary: jsonObj!)
                }
                self.completeFlag = 1
                
            }
        })
        task!.resume()
    }
    
    @IBAction func clickSend(sender: AnyObject) {
        if !WCSession.defaultSession().reachable {
            let alert = UIAlertController(title: "Failed to send", message: "Watch is not reachable", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        let content:[String:String] = ["x":PinchFinger.text!, "y":PinchStrength.text!, "z":GrabStrength.text!]
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

