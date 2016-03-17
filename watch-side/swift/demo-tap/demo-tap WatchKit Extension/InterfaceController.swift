//
//  InterfaceController.swift
//  demo-tap WatchKit Extension
//
//  Created by 欧长坤 on 16/3/17.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet private weak var countButton: WKInterfaceButton!
    
    var tapCounter: TapCounter
    var currentDevice: WKInterfaceDevice
    
    override init() {
        tapCounter = TapCounter()
        currentDevice = WKInterfaceDevice.currentDevice()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        tapCounter.load()
        countButton.setTitle("\(tapCounter.count)")
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @IBAction func addTapCounter() {
        currentDevice.playHaptic(.Success)
        tapCounter.add()
        tapCounter.save()
        countButton.setTitle("\(tapCounter.count)")
    }
    @IBAction func minusTapCounter() {
        currentDevice.playHaptic(.Failure)
        tapCounter.minus()
        tapCounter.save()
        countButton.setTitle("\(tapCounter.count)")
    }
    @IBAction func resetTapCounter() {
        currentDevice.playHaptic(.Stop)
        tapCounter.reset()
        countButton.setTitle("\(tapCounter.count)")
    }
}
