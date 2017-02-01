//
//  Configuration.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit

class Configuration: NSObject {
    static let sharedInstance :Configuration = Configuration()
    
    
    var appRunEnvironmentType :AppRunEnvironmentType {
        get {
            var aReturnVal :AppRunEnvironmentType = AppRunEnvironmentType.httpApi
            if UserDefaults.standard.dictionaryRepresentation().keys.contains("chatConversationType") {
                aReturnVal = AppRunEnvironmentType(rawValue: UserDefaults.standard.string(forKey: "chatConversationType")!)
            }
            return aReturnVal
        }
    }
    
    
    let sqliteRunEnvironmentResponseDelayInSeconds :Double = 2.0
}
