//
//  DataAdapterHttp.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 2/14/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit


class DataAdapterHttp: DataAdapter {
    
    internal override func login(_ pUser :User, completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        let aRequestType = DataAdapterRequestType.login
        
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
            
            let aDataAdapterResult = DataAdapterHttp.mapHttpResponse(requestType: aRequestType, responseStatusCode: pResponseStatusCode, responseHeaders: pResponseHeaders, responseBodyData: pResponseBodyData as Data?)
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
    }
    
    
    internal override func fetchAppletList(completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        let aRequestType = DataAdapterRequestType.fetchAppletList
        
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
            
            let aDataAdapterResult = DataAdapterHttp.mapHttpResponse(requestType: aRequestType, responseStatusCode: pResponseStatusCode, responseHeaders: pResponseHeaders, responseBodyData: pResponseBodyData as Data?)
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
    }
    
    
    internal override func updateApplet(_ pApplet :Applet, completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        let aRequestType = DataAdapterRequestType.updateApplet
        
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
            
            let aDataAdapterResult = DataAdapterHttp.mapHttpResponse(requestType: aRequestType, responseStatusCode: pResponseStatusCode, responseHeaders: pResponseHeaders, responseBodyData: pResponseBodyData as Data?)
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
                throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : (aMessage != nil ? (aMessage as String) : "Unknown Error")])
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
                    throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not map login response."])
                }
            } else if pRequestType == DataAdapterRequestType.fetchAppletList {
                if (aResponseDict is NSArray) {
                    let aDictArray :NSArray! = aResponseDict as! NSArray
                    let anAppletArray :Array<Applet>! = Applet.array(httpApiDictArray: aDictArray as! Array<[String : Any]>)
                    aReturnVal.result = anAppletArray
                } else {
                    throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not map fetch applet list response."])
                }
            }
        } catch {
            NSLog("mapHttpResponse exception")
            aReturnVal.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
        }
        
        return aReturnVal
    }
    
    
    internal func defaultHttpRequestHeaders() -> Array<[String:String]> {
        var aReturnVal :Array<[String:String]> = Array<[String:String]>()
        
        aReturnVal.append(["Content-Type" : "application/json; charset=utf-8"])
        aReturnVal.append(["Authorization" : "Bearer " + (GlobalData.loggedInUser != nil && GlobalData.loggedInUser.accessToken != nil ? GlobalData.loggedInUser.accessToken : "")])
        aReturnVal.append(["UserName" : (GlobalData.loggedInUser != nil && GlobalData.loggedInUser.userName != nil ? GlobalData.loggedInUser.userName : "")])
        
        return aReturnVal
    }
    
}
