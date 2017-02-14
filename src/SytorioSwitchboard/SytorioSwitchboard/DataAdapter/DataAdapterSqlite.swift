//
//  DataAdapterSqlite.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 2/14/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit


class DataAdapterSqlite: DataAdapter {
    
    internal override func login(_ pUser :User, completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Configuration.sharedInstance.sqliteRunEnvironmentResponseDelayInSeconds, execute: {() -> Void in
            let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
            
            let aRequestType = DataAdapterRequestType.login
            
            do {
                let anSqlQueryString :String = "SELECT applet_id AS AppletId, title AS Title, description AS Description, is_on AS IsOn FROM applets"
                let anSqlQueryValues :Array<AnyObject>! = nil
                let anSqlResult = try SQLiteManager.sharedInstance.executeQuery(anSqlQueryString, values: anSqlQueryValues)
                
                let aResult :DataAdapterResult = DataAdapterSqlite.mapSqliteResponse(requestType: aRequestType, sqliteResult: anSqlResult)
                aDataAdapterResult.result = aResult.result
                aDataAdapterResult.error = aResult.error
            } catch ATError.generic(let pErrorMessage) {
                aDataAdapterResult.result = nil
                aDataAdapterResult.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:pErrorMessage])
            } catch {
                aDataAdapterResult.result = nil
                aDataAdapterResult.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
            }
            
            DispatchQueue.main.async {
                pCompletion(aDataAdapterResult)
            }
        })
    }
    
    
    internal override func fetchAppletList(completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Configuration.sharedInstance.sqliteRunEnvironmentResponseDelayInSeconds, execute: {() -> Void in
            let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
            
            let aRequestType = DataAdapterRequestType.fetchAppletList
            
            do {
                let anSqlQueryString :String = "SELECT applet_id AS AppletId, title AS Title, description AS Description, is_on AS IsOn FROM applets"
                let anSqlQueryValues :Array<AnyObject>! = nil
                let anSqlResult = try SQLiteManager.sharedInstance.executeQuery(anSqlQueryString, values: anSqlQueryValues)
                
                let aResult :DataAdapterResult = DataAdapterSqlite.mapSqliteResponse(requestType: aRequestType, sqliteResult: anSqlResult)
                aDataAdapterResult.result = aResult.result
                aDataAdapterResult.error = aResult.error
            } catch ATError.generic(let pErrorMessage) {
                aDataAdapterResult.result = nil
                aDataAdapterResult.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:pErrorMessage])
            } catch {
                aDataAdapterResult.result = nil
                aDataAdapterResult.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
            }
            
            DispatchQueue.main.async {
                pCompletion(aDataAdapterResult)
            }
        })
    }
    
    
    internal override func updateApplet(_ pApplet :Applet, completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Configuration.sharedInstance.sqliteRunEnvironmentResponseDelayInSeconds, execute: {() -> Void in
            let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
            
            let aRequestType = DataAdapterRequestType.updateApplet
            
            do {
                let anSqlQueryString :String = "UPDATE applets SET title = ?, description = ?, is_on = ? WHERE applet_id = ?"
                var anSqlQueryValues = Array<AnyObject>()
                anSqlQueryValues.append(pApplet.title != nil ? (pApplet.title as AnyObject) : (NSNull() as AnyObject))
                anSqlQueryValues.append(pApplet.descriptionText != nil ? (pApplet.descriptionText as AnyObject) : (NSNull() as AnyObject))
                anSqlQueryValues.append(pApplet.isOn as AnyObject)
                anSqlQueryValues.append(pApplet.id != nil ? (pApplet.id as AnyObject) : (NSNull() as AnyObject))
                let anSqlResult = try SQLiteManager.sharedInstance.executeQuery(anSqlQueryString, values: anSqlQueryValues)
                
                let aResult :DataAdapterResult = DataAdapterSqlite.mapSqliteResponse(requestType: aRequestType, sqliteResult: anSqlResult)
                aDataAdapterResult.result = aResult.result
                aDataAdapterResult.error = aResult.error
            } catch ATError.generic(let pErrorMessage) {
                aDataAdapterResult.result = nil
                aDataAdapterResult.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:pErrorMessage])
            } catch {
                aDataAdapterResult.result = nil
                aDataAdapterResult.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
            }
            
            DispatchQueue.main.async {
                pCompletion(aDataAdapterResult)
            }
        })
    }
    
    
    // MARK: - Response Mapping Methods
    
    internal static func mapSqliteResponse(requestType pRequestType :DataAdapterRequestType, sqliteResult pSqliteResult:Array<[String:AnyObject]>?) -> DataAdapterResult {
        let aReturnVal = DataAdapterResult()
        
        do {
            if pRequestType == DataAdapterRequestType.login {
                let aUser = User()
                aUser.userName = Constants.loginUserName
                aReturnVal.result = aUser
            } else if pRequestType == DataAdapterRequestType.fetchAppletList {
                if pSqliteResult != nil && (pSqliteResult?.count)! >= 1 {
                    let anAppletArray :Array<Applet>! = Applet.array(sqliteDictArray: pSqliteResult!)
                    aReturnVal.result = anAppletArray
                } else {
                    throw ATError.generic("Can not map fetch applet list sqlite result.")
                }
            } else if pRequestType == DataAdapterRequestType.updateApplet {
                aReturnVal.result = true
            }
        } catch ATError.generic(let pErrorMessage) {
            NSLog("mapSqliteResponse error")
            aReturnVal.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:pErrorMessage])
        } catch {
            NSLog("mapSqliteResponse exception")
            aReturnVal.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
        }
        
        return aReturnVal
    }
}
