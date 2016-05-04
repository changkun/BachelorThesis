//
//  Networking.swift
//  1-Demo-Tap
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import Foundation

enum CompleteStatu {
    case Finish
    case Notyet
}
class Networking: NSObject {

    let url = NSURL(string: "http://192.168.1.102:10086")!
    let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
    var task: NSURLSessionDataTask?
    var session: NSURLSession!
    
    var gestureData: NSDictionary!
    
    var msgComplete: CompleteStatu = .Finish
    
    override init() {
        session = NSURLSession(configuration: conf)
        if session == nil {
            print("Network session create failed.")
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
//                    self.gesture = Gesture(fromDictionary: jsonObj!)
                    self.gestureData = jsonObj!
                }
                self.msgComplete = .Finish
            }
        })
        task!.resume()
    }
}