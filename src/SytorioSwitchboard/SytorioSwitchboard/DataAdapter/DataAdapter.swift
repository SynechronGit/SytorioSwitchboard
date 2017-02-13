//
//  DataAdapter.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit


class DataAdapter: NSObject {
    static let sharedInstance :DataAdapter = DataAdapter()
    
    
    internal func login(_ pUser :User, completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        let aRequestType = DataAdapterRequestType.login
        
        if Configuration.sharedInstance.appRunEnvironmentType == AppRunEnvironmentType.httpApi {
            let aNetworkManager :ATNetworkManager = ATNetworkManager()
            
            // Assign request id
            aNetworkManager.requestId = UUID().uuidString
            
            // Assign request url
            aNetworkManager.urlString = RequestUrl.login()
            
            // Assign request method
            aNetworkManager.httpMethod = "POST"
            
            // Assign request headers
            aNetworkManager.httpRequestHeaders = nil
            
            // Assign request body
            let anHttpRequestBodyString = "grant_type=password&username=" + pUser.userName + "&password=" + pUser.password + "&client_id=EnsembleFX"
            aNetworkManager.httpRequestBody = anHttpRequestBodyString.data(using: String.Encoding.utf8)
            
            // Assign request body form parameters
            aNetworkManager.httpRequestParameters = nil
            
            // Assign request attachments
            aNetworkManager.httpRequestAttachments = nil
            aNetworkManager.encodeAttachmentsInBase64 = false
            
            // Assign response mapper
            aNetworkManager.responseMapper = {pRequestId, pResponseStatusCode, pResponseHeaders, pResponseBodyData in
                let aReturnVal :ATNetworkManagerResult = ATNetworkManagerResult()
                
                let aDataAdapterResult = DataAdapter.mapHttpResponse(requestType: aRequestType, responseStatusCode: pResponseStatusCode, responseHeaders: pResponseHeaders, responseBodyData: pResponseBodyData as Data?)
                aReturnVal.error = aDataAdapterResult.error
                aReturnVal.result = aDataAdapterResult.result as AnyObject!
                
                return aReturnVal
            }
            
            // Send request
            aNetworkManager.sendRequest(completion: { (pNetworkManagerResult) in
                let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
                aDataAdapterResult.error = pNetworkManagerResult.error
                aDataAdapterResult.result = pNetworkManagerResult.result
                DispatchQueue.main.sync {
                    pCompletion(aDataAdapterResult)
                }
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Configuration.sharedInstance.sqliteRunEnvironmentResponseDelayInSeconds, execute: {() -> Void in
                let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
                aDataAdapterResult.error = nil
                let aUser = User()
                aUser.userName = Constants.loginUserName
                aDataAdapterResult.result = aUser
                DispatchQueue.main.async {
                    pCompletion(aDataAdapterResult)
                }
            })
        }
    }
    
    
    internal func fetchAppletList(completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        let aRequestType = DataAdapterRequestType.fetchAppletList
        
        if Configuration.sharedInstance.appRunEnvironmentType == AppRunEnvironmentType.httpApi {
            let aNetworkManager :ATNetworkManager = ATNetworkManager()
            
            // Assign request id
            aNetworkManager.requestId = UUID().uuidString
            
            // Assign request url
            aNetworkManager.urlString = RequestUrl.fetchAppletList()
            
            // Assign request method
            aNetworkManager.httpMethod = "GET"
            
            // Assign request headers
            aNetworkManager.httpRequestHeaders = self.defaultHttpRequestHeaders()
            
            // Assign request body
            aNetworkManager.httpRequestBody = nil
            
            // Assign request body form parameters
            aNetworkManager.httpRequestParameters = nil
            
            // Assign request attachments
            aNetworkManager.httpRequestAttachments = nil
            aNetworkManager.encodeAttachmentsInBase64 = false
            
            // Assign response mapper
            aNetworkManager.responseMapper = {pRequestId, pResponseStatusCode, pResponseHeaders, pResponseBodyData in
                let aReturnVal :ATNetworkManagerResult = ATNetworkManagerResult()
                
                let aDataAdapterResult = DataAdapter.mapHttpResponse(requestType: aRequestType, responseStatusCode: pResponseStatusCode, responseHeaders: pResponseHeaders, responseBodyData: pResponseBodyData as Data?)
                aReturnVal.error = aDataAdapterResult.error
                aReturnVal.result = aDataAdapterResult.result as AnyObject!
                
                return aReturnVal
            }
            
            // Send request
            aNetworkManager.sendRequest(completion: { (pNetworkManagerResult) in
                let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
                aDataAdapterResult.error = pNetworkManagerResult.error
                aDataAdapterResult.result = pNetworkManagerResult.result
                DispatchQueue.main.sync {
                    pCompletion(aDataAdapterResult)
                }
            })
        } else {
            let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
            
            do {
                let anSqlQueryString :String = "SELECT applet_id AS AppletId, title AS Title, description AS Description, is_on AS IsOn FROM applets"
                let anSqlQueryValues :Array<AnyObject>! = nil
                let anSqlResult = try SQLiteManager.sharedInstance.executeQuery(anSqlQueryString, values: anSqlQueryValues)
                
                let aResult :DataAdapterResult = DataAdapter.mapSqliteResponse(requestType: aRequestType, sqliteResult: anSqlResult)
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
        }
    }
    
    
    internal func updateApplet(_ pApplet :Applet, completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        let aRequestType = DataAdapterRequestType.updateApplet
        
        if Configuration.sharedInstance.appRunEnvironmentType == AppRunEnvironmentType.httpApi {
            let aNetworkManager :ATNetworkManager = ATNetworkManager()
            
            // Assign request id
            aNetworkManager.requestId = UUID().uuidString
            
            // Assign request url
            aNetworkManager.urlString = RequestUrl.updateApplet()
            
            // Assign request method
            aNetworkManager.httpMethod = "PUT"
            
            // Assign request headers
            aNetworkManager.httpRequestHeaders = self.defaultHttpRequestHeaders()
            
            // Assign request body
            var anHttpRequestBodyString = "{"
            anHttpRequestBodyString = anHttpRequestBodyString + "\"_id\" : \"" + pApplet.id + "\""
            anHttpRequestBodyString = anHttpRequestBodyString + ", \"AppletTitle\" : \"" + pApplet.title + "\""
            anHttpRequestBodyString = anHttpRequestBodyString + ", \"TriggerType\" : \"" + String(format: "%d", pApplet.triggerType.rawValue) + "\""
            anHttpRequestBodyString = anHttpRequestBodyString + ", \"WorkflowId\" : \"" + pApplet.workflowId + "\""
            anHttpRequestBodyString = anHttpRequestBodyString + ", \"AppletOnOff\" : " + (pApplet.isOn == true ? "true" : "false")
            anHttpRequestBodyString = anHttpRequestBodyString + "}"
            aNetworkManager.httpRequestBody = anHttpRequestBodyString.data(using: String.Encoding.utf8)
            
            // Assign request body form parameters
            aNetworkManager.httpRequestParameters = nil
            
            // Assign request attachments
            aNetworkManager.httpRequestAttachments = nil
            aNetworkManager.encodeAttachmentsInBase64 = false
            
            // Assign response mapper
            aNetworkManager.responseMapper = {pRequestId, pResponseStatusCode, pResponseHeaders, pResponseBodyData in
                let aReturnVal :ATNetworkManagerResult = ATNetworkManagerResult()
                
                let aDataAdapterResult = DataAdapter.mapHttpResponse(requestType: aRequestType, responseStatusCode: pResponseStatusCode, responseHeaders: pResponseHeaders, responseBodyData: pResponseBodyData as Data?)
                aReturnVal.error = aDataAdapterResult.error
                aReturnVal.result = aDataAdapterResult.result as AnyObject!
                
                return aReturnVal
            }
            
            // Send request
            aNetworkManager.sendRequest(completion: { (pNetworkManagerResult) in
                let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
                aDataAdapterResult.error = pNetworkManagerResult.error
                aDataAdapterResult.result = pNetworkManagerResult.result
                DispatchQueue.main.sync {
                    pCompletion(aDataAdapterResult)
                }
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Configuration.sharedInstance.sqliteRunEnvironmentResponseDelayInSeconds, execute: {() -> Void in
                let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
                aDataAdapterResult.error = nil
                aDataAdapterResult.result = nil
                DispatchQueue.main.async {
                    pCompletion(aDataAdapterResult)
                }
            })
        }
    }
    
    
    internal func defaultHttpRequestHeaders() -> Array<[String:String]> {
        var aReturnVal :Array<[String:String]> = Array<[String:String]>()
        
        aReturnVal.append(["Content-Type" : "application/json; charset=utf-8"])
        aReturnVal.append(["Authorization" : "Bearer " + (GlobalData.loggedInUser != nil && GlobalData.loggedInUser.accessToken != nil ? GlobalData.loggedInUser.accessToken : "")])
        aReturnVal.append(["UserName" : (GlobalData.loggedInUser != nil && GlobalData.loggedInUser.userName != nil ? GlobalData.loggedInUser.userName : "")])
        
        return aReturnVal
    }
    
    
    // MARK: - Response Mapping Methods
    
    internal static func mapHttpResponse(requestType pRequestType :DataAdapterRequestType, responseStatusCode pResponseStatusCode :Int?, responseHeaders pResponseHeaders:[AnyHashable:Any]?, responseBodyData pResponseBodyData:Data?) -> DataAdapterResult {
        let aReturnVal = DataAdapterResult()
        
        do {
            // Convert response data to json
            var aResponseDict :Any!
            do {
                if pResponseBodyData != nil {
                    aResponseDict = try JSONSerialization.jsonObject(with: pResponseBodyData!, options: JSONSerialization.ReadingOptions.allowFragments)
                }
            } catch {
                NSLog("JSONSerialization exception")
            }
            
            // Check response status code
            if pResponseStatusCode != 200 {
                var aMessage :String!
                if aResponseDict != nil {
                    aMessage = (aResponseDict as! NSDictionary).value(forKey: "error") as! String!
                }
                throw ATError.generic((aMessage != nil ? (aMessage as String) : "Unknown Error"))
            }
            
            // Map json response to model objects.
            if pRequestType == DataAdapterRequestType.login {
                if (aResponseDict is NSDictionary) {
                    let aUser = User()
                    aUser.id = (aResponseDict as! NSDictionary).value(forKey: "userId") as! String
                    aUser.userName = (aResponseDict as! NSDictionary).value(forKey: "userName") as! String
                    aUser.accessToken = (aResponseDict as! NSDictionary).value(forKey: "access_token") as! String
                    aReturnVal.result = aUser
                } else {
                    throw ATError.generic("Can not map login response.")
                }
            } else if pRequestType == DataAdapterRequestType.fetchAppletList {
                if (aResponseDict is NSArray) {
                    let aDictArray :NSArray! = aResponseDict as! NSArray
                    let anAppletArray :Array<Applet>! = Applet.array(httpApiDictArray: aDictArray as! Array<[String : Any]>)
                    aReturnVal.result = anAppletArray
                } else {
                    throw ATError.generic("Can not map fetch applet list response.")
                }
            }
        } catch ATError.generic(let pErrorMessage) {
            NSLog("mapHttpResponse error")
            aReturnVal.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:pErrorMessage])
        } catch {
            NSLog("mapHttpResponse exception")
            aReturnVal.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
        }
        
        return aReturnVal
    }
    
    
    internal static func mapSqliteResponse(requestType pRequestType :DataAdapterRequestType, sqliteResult pSqliteResult:Array<[String:AnyObject]>?) -> DataAdapterResult {
        let aReturnVal = DataAdapterResult()
        
        do {
            if pRequestType == DataAdapterRequestType.fetchAppletList {
                if pSqliteResult != nil && (pSqliteResult?.count)! >= 1 {
                    let anAppletArray :Array<Applet>! = Applet.array(sqliteDictArray: pSqliteResult!)
                    aReturnVal.result = anAppletArray
                } else {
                    throw ATError.generic("Can not map fetch applet list sqlite result.")
                }
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


class RequestUrl: NSObject {
    internal static func base() ->String {
        return "http://api.sytor.io"
    }
    
    internal static func login() ->String {
        return RequestUrl.base() + "/token"
    }
    
    internal static func fetchAppletList() ->String {
        return RequestUrl.base() + "/Api/IftttApplet/GetAll"
    }
    
    internal static func updateApplet() ->String {
        return RequestUrl.base() + "/Api/IftttApplet/Update"
    }
}


class DataAdapterResult: NSObject {
    var result: Any!
    var error: NSError!
}


public enum DataAdapterRequestType: String {
    case none = "none"
    case login = "login"
    case fetchAppletList = "fetchAppletList"
    case updateApplet = "updateApplet"
    
    
    static let allValues = [none, login, fetchAppletList, updateApplet]
    
    
    public init(rawValue pRawValue :String) {
        var aValue :DataAdapterRequestType = DataAdapterRequestType.none
        for aCase in DataAdapterRequestType.allValues {
            if aCase.rawValue == pRawValue {
                aValue = aCase
                break
            }
        }
        self = aValue
    }
}
