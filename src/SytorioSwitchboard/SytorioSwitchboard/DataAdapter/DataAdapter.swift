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
    
    internal func login(_ pUser :User, completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        fatalError("Subclass needs to implement this method.")
    }
    
    
    internal func fetchAppletList(completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        fatalError("Subclass needs to implement this method.")
    }
    
    
    internal func updateApplet(_ pApplet :Applet, completion pCompletion:@escaping (DataAdapterResult) -> Void) {
        fatalError("Subclass needs to implement this method.")
    }
    
}


class DataAdapterFactory: NSObject {
    private static var _sharedInstance :DataAdapter = DataAdapter()
    static var sharedDataAdapter :DataAdapter {
        get {
            if Configuration.sharedInstance.appRunEnvironmentType == AppRunEnvironmentType.httpApi
            && !DataAdapterFactory._sharedInstance.isKind(of: DataAdapterHttp.self) {
                DataAdapterFactory._sharedInstance = DataAdapterHttp()
            } else if Configuration.sharedInstance.appRunEnvironmentType == AppRunEnvironmentType.sqlite
                && !DataAdapterFactory._sharedInstance.isKind(of: DataAdapterSqlite.self) {
                DataAdapterFactory._sharedInstance = DataAdapterSqlite()
            }
            return DataAdapterFactory._sharedInstance
        }
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
