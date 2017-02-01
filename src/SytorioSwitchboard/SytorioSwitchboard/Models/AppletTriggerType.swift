//
//  AppletTriggerType.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 2/1/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit

enum AppletTriggerType :Int {
    case file = 0
    case email = 1
    case time = 2
    case manual = 3
    
    
    static let allValues = [file, email, time, manual]
    
    
    public init(rawValue pRawValue :Int) {
        var aValue :AppletTriggerType = AppletTriggerType.file
        for aCase in AppletTriggerType.allValues {
            if aCase.rawValue == pRawValue {
                aValue = aCase
                break
            }
        }
        self = aValue
    }
}
