//
//  TapCounter.swift
//  demo-tap
//
//  Created by 欧长坤 on 16/3/17.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import Foundation

private let key = "TapCounter"

struct TapCounter {
    
    private (set) var count = 0
    
    /**
     mutating 关键字
     
     Swift 中包含三种type: structure, enumaration, class
     1. 前两个是 value type，class 是 reference type
     2. structure 和 enumeration 也可以拥有 method (包括 instance method和 type method)
     3. instance method 不能修改 value type 的 property
     4. 为了能够在 instance method 中修改 value type 的 property，需要给 method 添加 mutating 关键字
        (为什么这么设计?)
     */
    mutating func add() {
        count += 1
    }
    mutating func minus() {
        count -= 1
    }
    
    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(count, forKey: key)
    }
    
    mutating func load() {
        count = NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
    mutating func reset() {
        count = 0
        save()
    }
    
}