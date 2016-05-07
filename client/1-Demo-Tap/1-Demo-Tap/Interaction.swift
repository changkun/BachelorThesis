//
//  Interaction.swift
//  1-Demo-Tap
//
//  Created by 欧长坤 on 16/5/4.
//  Copyright © 2016年 Changkun Ou. All rights reserved.
//

import Foundation

enum PinchGestureType {
    case IndexPinch
    case MiddlePinch
    case RingPinch
    case PinkyPinch
    case NoPinch
}

struct Interaction {
    
    var gesture : Gesture = Gesture()
    
    var lastGesture: PinchGestureType
    var currentGesture: PinchGestureType
    
    var lastForce: Double
    
    init() {
        gesture = Gesture()
        lastGesture = .NoPinch
        currentGesture = .NoPinch
        lastForce = 0.0
    }
    
    mutating func update(gesture: Gesture) {
        lastForce = self.gesture.forceValue
        self.gesture = gesture
        
        lastGesture = currentGesture
        currentGesture = recognize()
    }
    
    func recognize() -> PinchGestureType {
        var reco : PinchGestureType = .NoPinch
        
        switch Int(self.gesture.pinchIndex) {
        case 1:
            reco = .IndexPinch
        case 2:
            reco = .MiddlePinch
        case 3:
            reco = .RingPinch
        case 4:
            reco = .PinkyPinch
        default:
            reco = .NoPinch
        }
        
        return reco
    }
    
    func isGestureChanged() -> Bool {
        return currentGesture == lastGesture ? false : true
    }
    func isTaped() -> Bool {
        if currentGesture == .IndexPinch && lastGesture == .NoPinch {
            return true
        }
        return false
    }
//    func isForceTap() -> Bool {
//        if self.gesture.forceValue > 0.5 {
//            return true
//        }
//        return false
//    }
    func isForceTaped() -> Bool {
        if lastForce < 0.5 && self.gesture.forceValue >= 0.5 {
            return true
        }
        return false
    }
    func isCancelPinch() -> Bool {
        if currentGesture == .NoPinch && lastGesture == .IndexPinch {
            return true
        }
        return false
    }
}