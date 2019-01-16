//
//  ATLabel.swift
//  ATKit
//
//  Created by rupendra on 6/27/16.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit


public enum ATVerticalTextAlignment: Int {
    case top
    case middle
    case bottom
}


public enum ATLabelAnimationEffect: Int {
    case none
    case evaporate
}


//@IBDesignable
open class ATLabel: LTMorphingLabel {
    open var shouldDisplayUnderline :Bool = false
    open var verticalTextAlignment :ATVerticalTextAlignment = ATVerticalTextAlignment.middle
    
    private var _animationEffect :ATLabelAnimationEffect = ATLabelAnimationEffect.none
    open var animationEffect :ATLabelAnimationEffect {
        get {
            return _animationEffect
        }
        set {
            _animationEffect = newValue
            if _animationEffect == ATLabelAnimationEffect.none {
                self.morphingEnabled = false
            } else {
                self.morphingEnabled = true
            }
        }
    }
    open var animationDuration :Float = 1.5
    
    
    required public init(coder pDecoder: NSCoder) {
        super.init(coder:pDecoder)!
        self.initialize()
    }
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.initialize()
    }
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    
    func initialize() {
        if _animationEffect == ATLabelAnimationEffect.none {
            self.morphingEnabled = false
        } else {
            self.morphingEnabled = true
        }
    }
    
    
    override open func draw(_ rect: CGRect) {
        if self.shouldDisplayUnderline == true {
            let aCurrentContext = UIGraphicsGetCurrentContext()
            aCurrentContext?.setStrokeColor(red: self.textColor.redComponent, green: self.textColor.greenComponent, blue: self.textColor.blueComponent, alpha: self.textColor.alphaComponent)
            aCurrentContext?.setLineWidth(1.0)
            aCurrentContext?.move(to: CGPoint(x: 0, y: self.bounds.size.height - 1))
            aCurrentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - 1))
            aCurrentContext?.strokePath()
        }
        
        super.draw(rect)
    }
    
    
    override open func drawText(in rect: CGRect) {
        let aTargetRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: aTargetRect)
    }
    
    
    override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        var aReturnVal :CGRect = CGRect.zero
        
        let aTextRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        if self.verticalTextAlignment == ATVerticalTextAlignment.top {
            aReturnVal = CGRect(x: aTextRect.origin.x, y: bounds.origin.y, width: aTextRect.size.width, height: aTextRect.size.height)
        } else if self.verticalTextAlignment == ATVerticalTextAlignment.middle {
            aReturnVal = CGRect(x: aTextRect.origin.x, y: bounds.origin.y + (bounds.size.height - aTextRect.size.height) / 2, width: aTextRect.size.width, height: aTextRect.size.height)
        } else if self.verticalTextAlignment == ATVerticalTextAlignment.bottom {
            aReturnVal = CGRect(x: aTextRect.origin.x, y: bounds.origin.y + (bounds.size.height - aTextRect.size.height), width: aTextRect.size.width, height: aTextRect.size.height)
        } else {
            aReturnVal = aTextRect
        }
        
        return aReturnVal
    }
    
    
    open var animatedText: String! {
        set {
            if self.animationEffect == ATLabelAnimationEffect.evaporate {
                self.morphingEffect = LTMorphingEffect.evaporate
            } else {
                self.morphingEffect = LTMorphingEffect.scale
            }
            self.morphingDuration = self.animationDuration
            self.text = newValue
        }
        get {
            return self.text
        }
    }
}
