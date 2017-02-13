//
//  Applet.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/31/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit

class Applet: NSObject {
    var id :String!
    var title :String!
    var descriptionText :String!
    var triggerType :AppletTriggerType!
    var triggerId :String!
    var workflowId :String!
    var workflowDefinitionId :String!
    var isOn :Bool = false
    
    
    convenience init(httpApiDictionary pDictionary:Dictionary<String, Any>) {
        self.init()
        
        if pDictionary["_id"] is String {
            self.id = pDictionary["_id"] as! String
        }
        
        if pDictionary["AppletTitle"] is String {
            self.title = pDictionary["AppletTitle"] as! String
        }
        
        if pDictionary["Description"] is String {
            self.descriptionText = pDictionary["Description"] as! String
        }
        
        if pDictionary["AppletOnOff"] is Bool {
            self.isOn = pDictionary["AppletOnOff"] as! Bool
        }
        
        if pDictionary["TriggerType"] is Int {
            self.triggerType = AppletTriggerType(rawValue: pDictionary["TriggerType"] as! Int)
        }
        
        if pDictionary["WorkflowId"] is String {
            self.workflowId = pDictionary["WorkflowId"] as! String
        }
    }
    
    
    static func array(httpApiDictArray pDictArray:Array<[String:Any]>) -> Array<Applet>! {
        var aReturnVal :Array<Applet>! = Array<Applet>()
        
        for aDict in pDictArray {
            let anObject = Applet(httpApiDictionary: aDict)
            aReturnVal.append(anObject)
        }
        if aReturnVal.count <= 0 {
            aReturnVal = nil
        }
        
        return aReturnVal
    }
    
    
    convenience init(sqliteDictionary pDictionary:Dictionary<String, Any>) {
        self.init()
        
        if pDictionary["AppletId"] is String {
            self.id = pDictionary["AppletId"] as! String
        }
        
        if pDictionary["Title"] is String {
            self.title = pDictionary["Title"] as! String
        }
        
        if pDictionary["Description"] is String {
            self.descriptionText = pDictionary["Description"] as! String
        }
        
        if pDictionary["IsOn"] is Bool {
            self.isOn = pDictionary["IsOn"] as! Bool
        }
        
        if pDictionary["TriggerType"] is Int {
            self.triggerType = AppletTriggerType(rawValue: pDictionary["TriggerType"] as! Int)
        }
    }
    
    
    static func array(sqliteDictArray pDictArray:Array<[String:Any]>) -> Array<Applet>! {
        var aReturnVal :Array<Applet>! = Array<Applet>()
        
        for aDict in pDictArray {
            let anObject = Applet(sqliteDictionary: aDict)
            aReturnVal.append(anObject)
        }
        if aReturnVal.count <= 0 {
            aReturnVal = nil
        }
        
        return aReturnVal
    }
    
    
    var state :AppletState {
        get {
            var aReturnVal :AppletState = AppletState.notRunning
            
            if self.isOn {
                aReturnVal = AppletState.running
            } else {
                aReturnVal = AppletState.notRunning
            }
            
            return aReturnVal
        }
    }
}
