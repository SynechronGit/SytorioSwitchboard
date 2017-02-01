//
//  BaseController.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit

class BaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /**
     * Method that displays message as per given message type
     * @param: pMessage. String. Message that should be displayed.
     * @param: pType. MessageType. Message type that should be displayed.
     */
    internal func displayMessage(message pMessage: String, type pType: MessageType) {
        var aToastType :ATToastType = ATToastType.information
        if pType == MessageType.Success {
            aToastType = ATToastType.success
        } else if pType == MessageType.Error {
            aToastType = ATToastType.error
        } else if pType == MessageType.Information {
            aToastType = ATToastType.information
        } else {
            aToastType = ATToastType.information
        }
        ATToast.sharedInstance.show(message: pMessage, type: aToastType)
    }
    
}
