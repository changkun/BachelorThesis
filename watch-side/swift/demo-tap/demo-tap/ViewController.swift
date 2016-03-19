//
//  ViewController.swift
//  demo-tap
//
//  Created by 欧长坤 on 16/3/17.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

//https://172.20.55.54:5636/

import UIKit

class ViewController: UIViewController {
    
    var task: NSURLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSURL(string: "https://172.20.55.54:5636/")!
        let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: conf)
        task = session.dataTaskWithURL(url, completionHandler: { (data, res, err) -> Void in
            if let e = err {
                print("dataTaskWithURL fail: \(e.debugDescription)")
                return
            }
            if let d = data {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("\(d)")
                })
            }
        })
        task!.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

