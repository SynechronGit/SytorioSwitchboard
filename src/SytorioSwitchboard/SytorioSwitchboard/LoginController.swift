//
//  LoginController.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit


class LoginController: BaseController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userTextField.text = Constants.loginUserName
        self.passwordTextField.text = Constants.loginUserPassword
    }
    
    
    override func viewWillAppear(_ pAnimated: Bool) {
        super.viewWillAppear(pAnimated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func didSelectLoginButton(_ sender: Any) {
        Configuration.sharedInstance.appRunEnvironmentType = AppRunEnvironmentType.httpApi
        self.login()
    }
    
    
    @IBAction func didSelectForgotPasswordButton(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Constants.forgotPasswordUrl)!)
    }
    
    
    @IBAction func didSelectViewDemoButton(_ sender: Any) {
        Configuration.sharedInstance.appRunEnvironmentType = AppRunEnvironmentType.sqlite
        self.login()
    }
    
    
    func login() {
        let aUser = User()
        aUser.userName = self.userTextField.text
        aUser.password = self.passwordTextField.text
        
        ATOverlay.sharedInstance.show()
        DataAdapter.sharedInstance.login(aUser, completion: {(pDataAdapterResult) in
            ATOverlay.sharedInstance.hide()
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
