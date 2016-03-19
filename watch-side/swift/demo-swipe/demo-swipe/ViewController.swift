//
//  ViewController.swift
//  demo-swipe
//
//  Created by 欧长坤 on 16/3/19.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    var request: [String: AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //
    @IBAction func clickSend(sender: AnyObject) {
        
        // 检查消息是否可达
        if !WCSession.defaultSession().reachable {
            
            let alert = UIAlertController(title: "Failed to send Message", message: "Apple Watch is not reachable", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        // 发送测试消息
        let message = ["next":"yes", "prev":"no"]
        request = ["request": message]
        
        WCSession.defaultSession().sendMessage(request!, replyHandler: { (reply) -> Void in
            print(reply)
            }) { (error) -> Void in
                print(error)
        }
        
    }
    
    // TODO: - 从 iPhone 到 Watch 端的消息格式设计
    // 发送的消息按字典传送一共涉及以下字段：
    // next: yes or no
    // prev: yes or no
    // 以上两个字段两个值不能同时为 yes，即要么一个是 yes，要么一个是 no，要么两个都是 no
    // 这条消息的设计用于切换多个页面 controller
}

// 在这里书写 WatchConnectivity 相关协议代码
extension ViewController: WCSessionDelegate {

}
