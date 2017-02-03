//
//  Constants.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit


/**
 * Class to hold constants
 */
class Constants: NSObject {
    static var loginUserName = "ashish.nangla"
    static var loginUserPassword = "welcome1"
    static var forgotPasswordUrl = "http://sytor.io/#/forgot"
    
    
    static var appSqliteFileUrl :URL {
        get {
            var aReturnVal :URL! = nil
            
            let aDocumentDirectoryPath :String! = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let anAppDatabasePath = String(format: "%@/AppDatabase.sqlite", aDocumentDirectoryPath)
            aReturnVal = URL(fileURLWithPath: anAppDatabasePath)
            do {
                // If database is not available then create it. This code is written here so that all the other objects need not implement the database availability logic.
                if FileManager.default.fileExists(atPath: anAppDatabasePath) != true {
                    try FileManager.default.copyItem(atPath: Bundle.main.path(forResource: "AppDatabase", ofType: "sqlite")!, toPath: anAppDatabasePath)
                }
            } catch {
                NSLog("Can not copy app database.")
            }
            
            return aReturnVal
        }
    }
}


/**
 * Class to hold globally accessible variables
 */
class GlobalData: NSObject {
    static var loggedInUser :User!
}


/**
 * Enum to define different message types.
 */
public enum MessageType: Int {
    case Success
    case Error
    case Information
}


/**
 * Enum to define different run environment types.
 */
public enum AppRunEnvironmentType :String {
    case sqlite = "SQLITE"
    case httpApi = "HTTP_API"
    
    
    static let allValues = [sqlite, httpApi]
    
    
    public init(rawValue pRawValue :String) {
        var aValue :AppRunEnvironmentType = AppRunEnvironmentType.sqlite
        for aCase in AppRunEnvironmentType.allValues {
            if aCase.rawValue == pRawValue {
                aValue = aCase
                break
            }
        }
        self = aValue
    }
}
