//
//  AppletListController.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit


class AppletListController: BaseController {
    var applets :Array<Applet>!
    
    @IBOutlet weak var totalAppletCountLabel: UILabel!
    @IBOutlet weak var runningAppletCountLabel: UILabel!
    @IBOutlet weak var notRunningAppletCountLabel: UILabel!
    @IBOutlet weak var failedAppletCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.reloadAllData()
    }
    
    
    func reloadAllData() {
        ATOverlay.sharedInstance.show()
        DataAdapter.sharedInstance.fetchAppletList(completion: {(pDataAdapterResult) in
            ATOverlay.sharedInstance.hide()
            self.dataAdapterDidExecuteRequest(type: DataAdapterRequestType.fetchAppletList, result: pDataAdapterResult)
        })
    }
    
    
    func reloadAllView() {
        if self.applets != nil {
            var aRunningAppletCount = 0
            var aNotRunningAppletCount = 0
            var aFailedAppletCount = 0
            for anApplet in self.applets {
                if anApplet.state == AppletState.running {
                    aRunningAppletCount = aRunningAppletCount + 1
                } else if anApplet.state == AppletState.notRunning {
                    aNotRunningAppletCount = aNotRunningAppletCount + 1
                } else if anApplet.state == AppletState.failed {
                    aFailedAppletCount = aFailedAppletCount + 1
                }
            }
            self.totalAppletCountLabel.text = String(format: "%02d", self.applets.count)
            self.runningAppletCountLabel.text = String(format: "%02d", aRunningAppletCount)
            self.notRunningAppletCountLabel.text = String(format: "%02d", aNotRunningAppletCount)
            self.failedAppletCountLabel.text = String(format: "%02d", aFailedAppletCount)
        }
    }
    
    
    // MARK: - Data Adapter Methods
    
    internal func dataAdapterDidExecuteRequest(type pRequestType: DataAdapterRequestType, result pResult: DataAdapterResult) {
        if pResult.error == nil {
            if pRequestType == DataAdapterRequestType.fetchAppletList {
                if pResult.result is Array<Applet> {
                    self.applets = pResult.result as! Array<Applet>
                } else {
                    self.applets = nil
                }
                self.reloadAllView()
            }
        } else {
            self.displayMessage(message: pResult.error.localizedDescription, type: MessageType.Error)
        }
    }
}
