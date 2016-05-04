//
//  Gesture.swift
//  1-Demo-Tap
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import Foundation

struct Gesture {

    var pinchIndex: Double!
    var pinchStrength: Double!
    var grabStrength: Double!
    var forceValue: Double!
    
    init() {
        pinchIndex = -1.0
        pinchStrength = 0.0
        grabStrength = 0.0
        forceValue = 0.0
    }
    
    init(fromDictionary dictionary: NSDictionary) {
        pinchIndex = dictionary["pinchIndex"] as? Double
        pinchStrength = dictionary["pinchStrength"] as? Double
        grabStrength = dictionary["grabStrength"] as? Double
        forceValue = dictionary["forceValue"] as? Double
    }
    
    func toDictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()

        if pinchIndex != nil {
            dictionary["pinchIndex"] = pinchIndex
        }
        if pinchStrength != nil {
            dictionary["pinchStrength"] = pinchStrength
        }
        if grabStrength != nil {
            dictionary["grabStrength"] = grabStrength
        }
        if forceValue != nil {
            dictionary["forceValue"] = forceValue
        }
        return dictionary
    }
}