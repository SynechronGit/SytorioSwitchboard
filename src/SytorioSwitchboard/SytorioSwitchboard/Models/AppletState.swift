//
//  AppletState.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 2/1/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit

enum AppletState :Int {
    case running = 0
    case notRunning = 1
    case failed = 2
    
    
    static let allValues = [running, notRunning, failed]
    
    
    public init(rawValue pRawValue :Int) {
        var aValue :AppletState = AppletState.running
        for aCase in AppletState.allValues {
            if aCase.rawValue == pRawValue {
                aValue = aCase
                break
            }
        }
        self = aValue
    }
    
    
    var displayText :String {
        get {
            var aReturnVal :String = ""
            
            if self == AppletState.running {
                aReturnVal = "Running"
            } else if self == AppletState.running {
                aReturnVal = "Not Running"
            } else {
                aReturnVal = "Failed"
            }
            
            return aReturnVal
        }
    }
    
}
