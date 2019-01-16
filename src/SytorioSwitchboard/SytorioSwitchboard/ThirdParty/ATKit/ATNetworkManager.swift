//
//  ATNetworkManager.swift
//  ATKit
//
//  Created by rupendra on 8/26/16.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit


open class ATNetworkManagerResult: NSObject {
    open var result: AnyObject!
    open var error: NSError!
}


open class ATNetworkManagerAttachment: NSObject {
    open var requestParameterName :String!
    open var fileTitle :String!
    open var fileExtension :String!
    open var fileData :Data!
    
    
    public init(requestParameterName pRequestParameterName:String!, fileTitle pFileTitle:String!, fileExtenstion pFileExtenstion:String!, fileData pFileData :Data!) {
        super.init()
        
        self.requestParameterName = pRequestParameterName
        self.fileTitle = pFileTitle
        self.fileExtension = pFileExtenstion
        self.fileData = pFileData
    }
}



@objc public protocol ATNetworkManagerDelegate {
    @objc optional func atNetworkManagerDidExecuteRequest(sender pSender:ATNetworkManager, requestId pRequestId: String, result pResult: ATNetworkManagerResult)
    @objc optional func atNetworkManagerDidProgress(sender pSender:ATNetworkManager, requestId pRequestId: String, progress pProgress: Int)
}


open class ATNetworkManager: NSObject {
    private var urlConnection :NSURLConnection!
    private var responseStatusCode :Int!
    private var responseHeaders :[AnyHashable: Any]!
    private var responseBodyData :NSMutableData!
    
    open var enableLogging :Bool = true
    
    open var requestId :String!
    open var urlString :String = "http://example.com"
    open var httpMethod :String = "POST"
    open var httpRequestHeaders :Array<[String:String]>!
    open var httpRequestBody :Data!
    open var httpRequestParameters :[String:Data]!
    open var httpRequestAttachments :Array<ATNetworkManagerAttachment>!
    open var encodeAttachmentsInBase64 :Bool = false
    
    open var authenticationUsername :String!
    open var authenticationPassword :String!
    open var authenticationDomain :String!
    
    weak open var delegate :ATNetworkManagerDelegate!
    open var responseMapper : ((String?, Int?, [AnyHashable: Any]?, NSData?) -> ATNetworkManagerResult)!
    
    
    private func createRequest() -> URLRequest {
        // Create request
        let aRequest = NSMutableURLRequest(url: URL(string: self.urlString)!)
        aRequest.httpMethod = self.httpMethod
        
        // Assign request headers
        if self.httpRequestHeaders != nil {
            for anIndex in stride(from: 0, to: self.httpRequestHeaders.count, by: 1) {
                let aDict :[String:String] = self.httpRequestHeaders[anIndex]
                if aDict.count > 0 && aDict.first != nil && aDict.first?.key != nil && aDict.first?.value != nil {
                    aRequest.addValue((aDict.first?.value)!, forHTTPHeaderField: (aDict.first?.key)!)
                }
            }
        }
        
        // Assign request body
        if self.httpRequestBody != nil {
            aRequest.httpBody = self.httpRequestBody
        } else if (self.httpRequestParameters != nil && self.httpRequestParameters.keys.count > 0) || (self.httpRequestAttachments != nil && self.httpRequestAttachments.count > 0) {
            let aBoundary = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            aRequest.addValue(String(format: "multipart/form-data; boundary=%@", aBoundary), forHTTPHeaderField: "Content-Type")
            
            let aBodyData :NSMutableData = NSMutableData()
            
            if self.httpRequestParameters != nil {
                let aRequestParametersKeyArray = self.httpRequestParameters.keys
                for aRequestParametersKey :String in aRequestParametersKeyArray {
                    let aRequestParameterName :String = aRequestParametersKey
                    let aRequestParameterData :Data = self.httpRequestParameters[aRequestParametersKey]!
                    
                    aBodyData.append(String(format: "\r\n--%@\r\n", aBoundary).data(using: String.Encoding.utf8)!)
                    aBodyData.append(String(format: "Content-Disposition: form-data; name=\"%@\"\r\n", aRequestParameterName).data(using: String.Encoding.utf8)!)
                    aBodyData.append(String(format: "Content-Length: %lu\r\n", aRequestParameterData.count).data(using: String.Encoding.utf8)!)
                    aBodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                    aBodyData.append(aRequestParameterData)
                    // TODO: Take \r\n or -- at end as user parameter
                    aBodyData.append(String(format: "\r\n--%@--", aBoundary).data(using: String.Encoding.utf8)!)
                }
            }
            
            if self.httpRequestAttachments != nil {
                for anAttachment in self.httpRequestAttachments {
                    var aContentType :String!
                    if anAttachment.fileExtension != nil {
                        aContentType = ATMimeType(fileExtension: anAttachment.fileExtension).rawValue
                    }
                    if aContentType == nil {
                        aContentType = ATMimeType.applicationOctetStream.rawValue
                    }
                    let aRequestParameterName :String = (anAttachment.requestParameterName != nil ? anAttachment.requestParameterName : "")
                    var aRequestParameterData :Data = anAttachment.fileData
                    if self.encodeAttachmentsInBase64 {
                        let aRequestParameterDataBase64 :NSString = aRequestParameterData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as NSString
                        aRequestParameterData = aRequestParameterDataBase64.data(using: String.Encoding.utf8.rawValue)!
                    }
                    let aFileName :String = "" + (anAttachment.fileTitle != nil ? anAttachment.fileTitle : "") + (anAttachment.fileExtension != nil ? ("." + anAttachment.fileExtension) : "")
                    
                    aBodyData.append(String(format: "\r\n--%@\r\n", aBoundary).data(using: String.Encoding.utf8)!)
                    aBodyData.append(String(format: "Content-Type: %@\r\n", aContentType).data(using: String.Encoding.utf8)!)
                    aBodyData.append(String(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", aRequestParameterName, aFileName).data(using: String.Encoding.utf8)!)
                    aBodyData.append(String(format: "Content-Length: %lu\r\n", aRequestParameterData.count).data(using: String.Encoding.utf8)!)
                    aBodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                    aBodyData.append(aRequestParameterData)
                    // TODO: Take \r\n or -- at end as user parameter
                    aBodyData.append(String(format: "\r\n--%@--", aBoundary).data(using: String.Encoding.utf8)!)
                }
            }
            
            aRequest.httpBody = aBodyData as Data
        }
        
        // Return request
        return aRequest as URLRequest
    }
    
    
    public func sendRequest(asynchronously pAsynchronously: Bool) {
        // Send request
        if pAsynchronously {
            let aRequest = self.createRequest()
            let aConnection: NSURLConnection = NSURLConnection(request: aRequest, delegate: self, startImmediately: true)!
            aConnection.start()
        }
    }
    
    
    public func sendRequest(completion pCompletion:@escaping (ATNetworkManagerResult) -> Void) {
        let aRequest = self.createRequest()
        if self.enableLogging {
            self.logRequest(aRequest)
        }
        
        let aDataTask = URLSession.shared.dataTask(with: aRequest, completionHandler:{(pData, pURLResponse, pError) in
            var aNetworkManagerResult :ATNetworkManagerResult = ATNetworkManagerResult()
            
            if pError != nil {
                aNetworkManagerResult.error = pError as NSError!
                aNetworkManagerResult.result = nil
            } else {
                self.responseStatusCode = (pURLResponse as! HTTPURLResponse).statusCode
                
                self.responseHeaders = (pURLResponse as! HTTPURLResponse).allHeaderFields
                if self.responseHeaders != nil && self.responseHeaders.keys.count <= 0 {
                    self.responseHeaders = nil
                }
                
                if pData != nil {
                    self.responseBodyData = NSMutableData(data: pData!)
                } else {
                    self.responseBodyData = nil
                }
                if self.responseBodyData != nil && self.responseBodyData.length <= 0 {
                    self.responseBodyData = nil
                }
                
                if self.enableLogging {
                    self.logResponse()
                }
                
                if self.responseMapper != nil {
                    aNetworkManagerResult = (self.responseMapper?(self.requestId, self.responseStatusCode, self.responseHeaders, self.responseBodyData))!
                }
            }
            
            pCompletion(aNetworkManagerResult)
        })
        aDataTask.resume()
    }
    
    
    private func logRequest(_ pRequest :URLRequest) {
        var aLogString :String = ""
        aLogString = aLogString + "\n-------------------------"
        aLogString = aLogString + String(format: "\n## Request URL (%@):\n%@", (self.requestId != nil ? self.requestId : ""), (pRequest.url?.absoluteString)!)
        if pRequest.allHTTPHeaderFields != nil {
            var aRequestHeaderString = ""
            for aDict in pRequest.allHTTPHeaderFields! {
                aRequestHeaderString = aRequestHeaderString + aDict.0 + " : " + aDict.1 + "\n"
            }
            aRequestHeaderString = aRequestHeaderString.trimmingCharacters(in: CharacterSet.newlines)
            aLogString = aLogString + String(format: "\n\n## Request Headers (%@):\n%@", (self.requestId != nil ? self.requestId : ""), aRequestHeaderString)
        }
        if pRequest.httpBody != nil {
            let aRequestBody :String! = String(data: pRequest.httpBody!, encoding: String.Encoding.utf8)
            aLogString = aLogString + String(format: "\n\n## Request Body (%@):\n%@", (self.requestId != nil ? self.requestId : ""), (aRequestBody != nil ? aRequestBody : String(format: "<BINARY(Length:%lu)>", (pRequest.httpBody?.count)!)))
        }
        aLogString = aLogString + "\n\n"
        NSLog("%@", aLogString)
    }
    
    
    private func logResponse() {
        var aLogString :String = ""
        aLogString = aLogString + String(format: "\n## Response Status Code (%@):\n%d", (self.requestId != nil ? self.requestId : ""), (self.responseStatusCode != nil ? self.responseStatusCode : 0))
        if self.responseHeaders != nil {
            var aResponseHeaderString = ""
            for aDict in self.responseHeaders! {
                aResponseHeaderString = aResponseHeaderString + (aDict.0 is String ? (aDict.0 as! String) : "<OBJECT>") + " : " + (aDict.1 is String ? (aDict.1 as! String) : "<OBJECT>") + "\n"
            }
            aResponseHeaderString = aResponseHeaderString.trimmingCharacters(in: CharacterSet.newlines)
            aLogString = aLogString + String(format: "\n\n## Response Headers (%@):\n%@", (self.requestId != nil ? self.requestId : ""), aResponseHeaderString)
        }
        var aResponseBody :String! = nil
        if self.responseBodyData != nil {
            aResponseBody = String(data: self.responseBodyData as Data, encoding: String.Encoding.utf8)
        }
        aLogString = aLogString + String(format: "\n\n## Response Body (%@):\n%@", (self.requestId != nil ? self.requestId : ""), (aResponseBody != nil ? aResponseBody : ""))
        aLogString = aLogString + "\n-------------------------"
        NSLog("%@", aLogString)
    }
    
    
    // MARK: NSURLConnection Methods
    
    func connection(_ connection: NSURLConnection, willSendRequest request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
        if self.enableLogging {
            self.logRequest(connection.currentRequest)
        }
        return request
    }
    
    
    func connection(_ connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: URLAuthenticationChallenge!){
        NSLog("didReceiveAuthenticationChallenge")
        
        if challenge.previousFailureCount < 1 {
            let aCredential = URLCredential(user: self.authenticationDomain + "\\" + self.authenticationUsername, password: self.authenticationPassword, persistence: URLCredential.Persistence.forSession)
            challenge.sender?.use(aCredential, for: challenge)
        }
    }
    
    
    func connection(_ connection: NSURLConnection, didFailWithError error: NSError) {
        if self.enableLogging {
            NSLog("connection:didFailWithError: %@", error.localizedDescription)
        }
        let aNetworkManagerResult :ATNetworkManagerResult = ATNetworkManagerResult()
        aNetworkManagerResult.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
        self.delegate?.atNetworkManagerDidExecuteRequest?(sender: self, requestId: self.requestId, result: aNetworkManagerResult)
    }
    
    
    func connection(_ connection: NSURLConnection, didReceiveResponse response: URLResponse) {
        self.responseStatusCode = (response as! HTTPURLResponse).statusCode
        self.responseHeaders = (response as! HTTPURLResponse).allHeaderFields
        self.responseBodyData = NSMutableData()
    }
    
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!) {
        self.responseBodyData.append(data)
    }
    
    
    func connectionDidFinishLoading(_ connection: NSURLConnection!) {
        if self.enableLogging {
            self.logResponse()
        }
        
        if self.responseHeaders != nil && self.responseHeaders.keys.count <= 0 {
            self.responseHeaders = nil
        }
        if self.responseBodyData != nil && self.responseBodyData.length <= 0 {
            self.responseBodyData = nil
        }
        var aNetworkManagerResult :ATNetworkManagerResult = ATNetworkManagerResult()
        if self.responseMapper != nil {
            aNetworkManagerResult = (self.responseMapper?(self.requestId, self.responseStatusCode, self.responseHeaders, self.responseBodyData))!
        }
        self.delegate?.atNetworkManagerDidExecuteRequest?(sender: self, requestId: self.requestId, result: aNetworkManagerResult)
    }
}
