//
//  CrownGesture.swift
//  demo-crown-circle
//
//  Created by 欧长坤 on 16/3/20.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import Foundation

struct CrownGesture{
    
    var grabStrength : Double!
    var pinchIndex : Double!
    var pinchStrength : Double!
    
    /**
     从一个字典初始化对象
     
     - parameter dictionary: {"pinchIndex":-1,"pinchStrength":0,"grabStrength":1}
     
     - returns: 没有返回对象
     */
    init(fromDictionary dictionary: NSDictionary) {
        grabStrength = dictionary["grabStrength"] as? Double
        pinchIndex = dictionary["pinchIndex"] as? Double
        pinchStrength = dictionary["pinchStrength"] as? Double
    }
    
    /**
     <#Description#>
     
     - returns: <#return value description#>
     */
    func toDictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        if grabStrength != nil{
            dictionary["grabStrength"] = grabStrength
        }
        if pinchIndex != nil{
            dictionary["pinchIndex"] = pinchIndex
        }
        if pinchStrength != nil{
            dictionary["pinchStrength"] = pinchStrength
        }
        return dictionary
    }
    
}