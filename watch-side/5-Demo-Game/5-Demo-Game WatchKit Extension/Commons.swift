//
//  Commons.swift
//  5-Demo-Game
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import Foundation
import WatchKit

//Two players
enum Player {
    case A, B
}

//helper for GCD delay
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

//generates random numbers
public extension Double {
    public static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    public static func random(min min: Double, max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}

public extension CGFloat {
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}

