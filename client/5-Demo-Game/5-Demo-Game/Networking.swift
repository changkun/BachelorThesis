//
//  Networking.swift
//  5-Demo-Game
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
    
    var url: NSURL
    let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
    var task: NSURLSessionDataTask?
    var session: NSURLSession!
    
    var gestureData: NSDictionary!
    
    var msgComplete: CompleteStatu = .Finish
    
    init(URL: String) {
        let fullAddress = "http://" + URL + ":10086"
        url = NSURL(string: fullAddress)!
        session = NSURLSession(configuration: conf)
        if session == nil {
            print("Network session create failed.")
        }
    }
    
    func isConnected() -> Bool {
        var connected = true
        let semaphore = dispatch_semaphore_create(0)
        session.dataTaskWithURL(url, completionHandler: { (data, res, error) in
            if error != nil {
                connected = false
            }
            dispatch_semaphore_signal(semaphore)
        }).resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return connected
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
            if data != nil {
                if let jsonObj = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                    self.gestureData = jsonObj!
                }
                self.msgComplete = .Finish
            }
        })
        task!.resume()
    }
}