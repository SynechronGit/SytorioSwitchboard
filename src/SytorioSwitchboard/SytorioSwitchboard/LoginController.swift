//
//  LoginController.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit

class LoginController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func didSelectLoginButton(_ sender: Any) {
        let aUser = User()
        aUser.userName = Constants.loginUserName
        aUser.password = Constants.loginUserPassword
        DataAdapter.sharedInstance.login(aUser, completion: {(pDataAdapterResult) in
            self.dataAdapterDidExecuteRequest(type: DataAdapterRequestType.login, result: pDataAdapterResult)
        })
    }
    
    
    // MARK: - Data Adapter Methods
    
    internal func dataAdapterDidExecuteRequest(type pRequestType: DataAdapterRequestType, result pResult: DataAdapterResult) {
        if pResult.error == nil {
            if pRequestType == DataAdapterRequestType.login {
                if pResult.result is User {
                    GlobalData.loggedInUser = pResult.result as! User
                    self.performSegue(withIdentifier: "LoginToAppletListSegueId", sender: self)
                }
            }
        } else {
            self.displayMessage(message: pResult.error.localizedDescription, type: MessageType.Error)
        }
    }
}
