//
//  AppDelegate.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        // Use ATWindow as custom window to take advantage of default implementations.
        ATWindow(frame: UIScreen.main.bounds)
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.bootstrap()
        
        BITHockeyManager.shared().configure(withIdentifier: "86f7ae3122124db2ada4c594735b8667")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation() // This line is obsolete in the crash only builds
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.beginBackgroundTask()
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        BackgroundTaskManager.sharedInstance.shutdown()
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func bootstrap() {
        SQLiteManager.sharedInstance.sqliteFileUrl = Constants.appSqliteFileUrl
    }
    
    
    func beginBackgroundTask() {
        UIApplication.shared.beginBackgroundTask(expirationHandler: {
            BackgroundTaskManager.sharedInstance.shutdown()
        })
        BackgroundTaskManager.sharedInstance.bootstrap()
    }
}
