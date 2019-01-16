//
//  ProgressOverlay.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/16/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import ATKit

class ProgressOverlay: NSObject {
    public static var sharedInstance :ProgressOverlay = {
        let aReturnVal = ProgressOverlay()
        ATProgressOverlay.sharedInstance.shouldBlurBackground = false
        return aReturnVal
    }()
    
    
    func show() {
        ATProgressOverlay.sharedInstance.show()
    }
    
    
    func hide() {
        ATProgressOverlay.sharedInstance.hide()
    }
}
