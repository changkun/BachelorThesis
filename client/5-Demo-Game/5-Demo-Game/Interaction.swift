//
//  Interaction.swift
//  5-Demo-Game
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import Foundation

struct Interaction {
    
    var gesture : Gesture = Gesture()
    
    init() {
        gesture = Gesture()
    }
    
    mutating func update(gesture: Gesture) {
        self.gesture = gesture
    }
}