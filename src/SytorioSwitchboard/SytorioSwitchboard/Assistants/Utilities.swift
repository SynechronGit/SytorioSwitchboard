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


public extension UIColor {
    convenience init(hexString pHexString:String) {
        var aHexString:String = pHexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if aHexString.hasPrefix("#") {
            aHexString = aHexString.substring(from: aHexString.characters.index(aHexString.startIndex, offsetBy: 1))
        }
        
        var aRedComponent :CGFloat = 0.0
        var aGreenComponent :CGFloat = 0.0
        var aBlueComponent :CGFloat = 0.0
        let anAlphaComponent :CGFloat = 1.0
        
        if aHexString.characters.count == 6 {
            var anRgbValue:UInt32 = 0
            Scanner(string: aHexString).scanHexInt32(&anRgbValue)
            
            aRedComponent = CGFloat((anRgbValue & 0xFF0000) >> 16) / 255.0
            aGreenComponent = CGFloat((anRgbValue & 0x00FF00) >> 8) / 255.0
            aBlueComponent = CGFloat(anRgbValue & 0x0000FF) / 255.0
        }
        
        self.init(red: aRedComponent, green: aGreenComponent, blue: aBlueComponent, alpha: anAlphaComponent)
    }
    
    
    public var redComponent :CGFloat {
        get {
            var aReturnVal :CGFloat = 0.0
            
            let aComponentPointer = self.cgColor.components
            let aComponentCount = self.cgColor.numberOfComponents
            if aComponentCount >= 1 {
                aReturnVal = (aComponentPointer?[0])!
            }
            
            return aReturnVal
        }
    }
    
    
    public var greenComponent :CGFloat {
        get {
            var aReturnVal :CGFloat = 0.0
            
            let aComponentPointer = self.cgColor.components
            let aComponentCount = self.cgColor.numberOfComponents
            if aComponentCount >= 2 {
                aReturnVal = (aComponentPointer?[1])!
            }
            
            return aReturnVal
        }
    }
    
    
    public var blueComponent :CGFloat {
        get {
            var aReturnVal :CGFloat = 0.0
            
            let aComponentPointer = self.cgColor.components
            let aComponentCount = self.cgColor.numberOfComponents
            if aComponentCount >= 3 {
                aReturnVal = (aComponentPointer?[2])!
            }
            
            return aReturnVal
        }
    }
    
    
    public var alphaComponent :CGFloat {
        get {
            var aReturnVal :CGFloat = 0.0
            
            let aComponentPointer = self.cgColor.components
            let aComponentCount = self.cgColor.numberOfComponents
            if aComponentCount >= 4 {
                aReturnVal = (aComponentPointer?[3])!
            }
            
            return aReturnVal
        }
    }
}
