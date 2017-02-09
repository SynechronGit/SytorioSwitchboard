//
//  BackgroundTaskManager.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 2/9/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import UserNotifications


class BackgroundTaskManager: NSObject {
    static let sharedInstance :BackgroundTaskManager = BackgroundTaskManager()
    
    var applets :Array<Applet>!
    var updateAppletsTimer :Timer!
    
    
    func bootstrap()  {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (pIsAuthorizationGranted, pError) in
                DispatchQueue.main.async {
                    if pIsAuthorizationGranted {
                        if self.updateAppletsTimer != nil && self.updateAppletsTimer.isValid {
                            self.updateAppletsTimer.invalidate()
                        }
                        self.updateAppletsTimer = Timer.scheduledTimer(timeInterval: Constants.updateAppletsIntervalSeconds, target: self, selector: #selector(BackgroundTaskManager.updateAppletList), userInfo: nil, repeats: true)
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func shutdown()  {
        if self.updateAppletsTimer != nil && self.updateAppletsTimer.isValid {
            self.updateAppletsTimer.invalidate()
        }
    }
    
    
    func updateAppletList() {
        if GlobalData.loggedInUser != nil && GlobalData.loggedInUser.accessToken != nil {
            DataAdapter.sharedInstance.fetchAppletList(completion: {(pDataAdapterResult) in
                self.dataAdapterDidExecuteRequest(type: DataAdapterRequestType.fetchAppletList, result: pDataAdapterResult)
            })
        }
    }
    
    
    // MARK: - Data Adapter Methods
    
    private func dataAdapterDidExecuteRequest(type pRequestType: DataAdapterRequestType, result pResult: DataAdapterResult) {
        if pResult.error == nil {
            if pRequestType == DataAdapterRequestType.fetchAppletList {
                if pResult.result is Array<Applet> {
                    let anAppletArray :Array<Applet> = pResult.result as! Array<Applet>
                    
                    if self.applets != nil {
                        var aStateChangeAppletCount :Int = 0
                        var aStateChangeAppletTitle :String! = nil
                        var aStateChangeAppletOldState :AppletState! = nil
                        var aStateChangeAppletNewState :AppletState! = nil
                        for aNewApplet in anAppletArray {
                            for anApplet in self.applets {
                                if anApplet.id == aNewApplet.id && anApplet.state != aNewApplet.state {
                                    aStateChangeAppletCount = aStateChangeAppletCount + 1
                                    aStateChangeAppletTitle = aNewApplet.title
                                    aStateChangeAppletOldState = anApplet.state
                                    aStateChangeAppletNewState = aNewApplet.state
                                    break
                                }
                            }
                        }
                        if aStateChangeAppletCount > 0 {
                            DispatchQueue.main.async {
                                let aNotification :UILocalNotification = UILocalNotification()
                                if aStateChangeAppletCount == 1 {
                                    aNotification.alertBody = String(format: "State for applet \"%@\" has changed from \"%@\" to \"%@\".", aStateChangeAppletTitle, aStateChangeAppletOldState.displayText, aStateChangeAppletNewState.displayText)
                                } else {
                                    aNotification.alertBody = String(format: "%d applets have their state changed.", aStateChangeAppletCount)
                                }
                                aNotification.alertAction = "OK"
                                aNotification.fireDate = Date(timeIntervalSinceNow: 1.0)
                                UIApplication.shared.scheduledLocalNotifications = [aNotification]
                            }
                        }
                    }
                    
                    self.applets = anAppletArray
                } else {
                    self.applets = nil
                }
            }
        }
    }
}
