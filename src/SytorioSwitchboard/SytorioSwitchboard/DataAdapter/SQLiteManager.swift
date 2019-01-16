//
//  SQLiteManager.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/31/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit


class SQLiteManager: NSObject {
    static let sharedInstance :SQLiteManager = SQLiteManager()
    
    public var sqliteFileUrl :URL!
    
    
    public func executeQuery(_ pQuery:String!, values pValues:Array<AnyObject>!) throws -> Array<[String:AnyObject]>! {
        var aReturnVal :Array<[String:AnyObject]>! = Array()
        
        do {
            var aDatabaseHandle: OpaquePointer? = nil
            let anOpenDatabaseResult = sqlite3_open(self.sqliteFileUrl.absoluteString, &aDatabaseHandle)
            if anOpenDatabaseResult != SQLITE_OK {
                throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : String(format: "Can not open database. Error: %d", anOpenDatabaseResult)])
            }
            
            var anSqliteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(aDatabaseHandle, pQuery, -1, &anSqliteStatement, nil) == SQLITE_OK {
                if pValues != nil && pValues.count > 0 {
                    for anIndex in 0..<pValues.count {
                        let aValue = pValues[anIndex]
                        if aValue is String {
                            if sqlite3_bind_text(anSqliteStatement, Int32(anIndex + 1), (aValue as! NSString).utf8String, -1, nil) != SQLITE_OK {
                                throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not bind value."])
                            }
                        } else if aValue is NSNumber {
                            if sqlite3_bind_int(anSqliteStatement, Int32(anIndex + 1), Int32((aValue as! NSNumber).intValue)) != SQLITE_OK {
                                throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not bind value."])
                            }
                        } else if aValue is NSNull {
                            if sqlite3_bind_null(anSqliteStatement, Int32(anIndex + 1)) != SQLITE_OK {
                                throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not bind value."])
                            }
                        } else if aValue is NSData {
                            if sqlite3_bind_blob(anSqliteStatement, Int32(anIndex + 1), (aValue as! NSData).bytes, Int32((aValue as! NSData).length), nil) != SQLITE_OK {
                                throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not bind value."])
                            }
                        }
                    }
                }
            } else {
                let anErrorMessage = String(cString: sqlite3_errmsg(aDatabaseHandle))
                throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : ("Can not prepare statement. Error: " + anErrorMessage)])
            }
            
            while true {
                let anSqliteStepResult = sqlite3_step(anSqliteStatement)
                if anSqliteStepResult == SQLITE_ROW {
                    let aColumnCount :Int = Int(sqlite3_column_count(anSqliteStatement))
                    
                    var aRow = Dictionary<String, AnyObject>()
                    for aColumnIndex in 0..<aColumnCount {
                        let aColumnName :String! = String(cString: UnsafePointer<CChar>(sqlite3_column_name(anSqliteStatement, Int32(aColumnIndex))))
                        
                        let aColumnType :Int32 = sqlite3_column_type(anSqliteStatement, Int32(aColumnIndex))
                        
                        var aColumnValue :AnyObject!
                        if aColumnType == SQLITE_INTEGER {
                            aColumnValue = NSNumber(value: sqlite3_column_int(anSqliteStatement, Int32(aColumnIndex)))
                        } else if aColumnType == SQLITE_FLOAT {
                            aColumnValue = NSNumber(value: sqlite3_column_double(anSqliteStatement, Int32(aColumnIndex)))
                        } else if aColumnType == SQLITE_BLOB {
                            let aDataLength = Int(sqlite3_column_bytes(anSqliteStatement, Int32(aColumnIndex)))
                            aColumnValue = NSData(bytes: sqlite3_column_blob(anSqliteStatement, Int32(aColumnIndex)), length: aDataLength)
                        } else if aColumnType == SQLITE_NULL {
                            aColumnValue = NSNull()
                        } else if aColumnType == SQLITE_TEXT || aColumnType == SQLITE3_TEXT {
                            let aValue = sqlite3_column_text(anSqliteStatement, Int32(aColumnIndex))
                            if aValue != nil {
                                aColumnValue = String(cString: aValue!) as AnyObject
                            }
                        }
                        aRow.updateValue(aColumnValue, forKey: aColumnName)
                    }
                    if aRow.count > 0 {
                        aReturnVal.append(aRow)
                    }
                } else if anSqliteStepResult == SQLITE_DONE {
                    break
                } else {
                    throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not step statement."])
                }
            }
            
            if sqlite3_finalize(anSqliteStatement) != SQLITE_OK {
                let anErrorMessage = String(cString: sqlite3_errmsg(aDatabaseHandle))
                throw NSError(domain: "error", code: 1, userInfo: [NSLocalizedDescriptionKey : String(format: "Can not finalize statement. Error: %@", anErrorMessage)])
            }
            
            defer {
                if aDatabaseHandle != nil {
                    sqlite3_close(aDatabaseHandle)
                }
            }
        } catch {
            throw error
        }
        
        if aReturnVal.count <= 0 {
            aReturnVal = nil
        }
        
        return aReturnVal
    }
    
}
