//
//  Utilities.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 2/20/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    static func animation(_ pView:UIView, type pType:AnimationType, length pLength:CGFloat, duration pDuration:CFTimeInterval, fdTag pFdTag: String, delegate pDelegate:CAAnimationDelegate?) -> CABasicAnimation {
        var aReturnVal: CABasicAnimation
        
        aReturnVal = CABasicAnimation()
        aReturnVal.duration = pDuration
        aReturnVal.delegate = pDelegate
        aReturnVal.setValue(pFdTag, forKey: "animationTag")
        aReturnVal.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        if pType == AnimationType.topToBottom {
            aReturnVal.fromValue = NSValue(cgPoint: CGPoint(x: pView.center.x, y: pView.center.y - pLength))
            aReturnVal.toValue = NSValue(cgPoint: CGPoint(x: pView.center.x, y: pView.center.y))
        } else if pType == AnimationType.bottomToTop {
            aReturnVal.fromValue = NSValue(cgPoint: CGPoint(x: pView.center.x, y: pView.center.y + pLength))
            aReturnVal.toValue = NSValue(cgPoint: CGPoint(x: pView.center.x, y: pView.center.y))
        } else if pType == AnimationType.rightToLeft {
            aReturnVal.fromValue = NSValue(cgPoint: CGPoint(x: pView.center.x + pLength, y: pView.center.y))
            aReturnVal.toValue = NSValue(cgPoint: CGPoint(x: pView.center.x, y: pView.center.y))
        } else if pType == AnimationType.leftToRight {
            aReturnVal.fromValue = NSValue(cgPoint: CGPoint(x: pView.center.x - pLength, y: pView.center.y))
            aReturnVal.toValue = NSValue(cgPoint: CGPoint(x: pView.center.x, y: pView.center.y))
        } else if pType == AnimationType.fadeIn {
            aReturnVal.keyPath = "opacity"
            aReturnVal.fromValue = NSNumber(value: 0.0)
            aReturnVal.toValue = NSNumber(value: 1.0)
            aReturnVal.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        } else if pType == AnimationType.fadeOut {
            aReturnVal.keyPath = "opacity"
            aReturnVal.fromValue = NSNumber(value: 1.0)
            aReturnVal.toValue = NSNumber(value: 0.0)
            aReturnVal.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        }
        
        return aReturnVal
    }
}


public enum AnimationType : Int {
    case topToBottom
    case bottomToTop
    case rightToLeft
    case leftToRight
    case fadeIn
    case fadeOut
}
