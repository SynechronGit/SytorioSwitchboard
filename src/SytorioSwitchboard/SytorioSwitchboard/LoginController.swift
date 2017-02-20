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
    @IBOutlet weak var userBottomBorderView: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordBottomBorderView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var viewDemoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userTextField.text = Constants.loginUserName
        self.passwordTextField.text = Constants.loginUserPassword
    }
    
    
    override func viewWillAppear(_ pAnimated: Bool) {
        super.viewWillAppear(pAnimated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.prepareForAnimation()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startAnimation()
    }
    
    
    func prepareForAnimation() {
        self.userTextField.isHidden = true
        self.userBottomBorderView.isHidden = true
        self.passwordTextField.isHidden = true
        self.passwordBottomBorderView.isHidden = true
        self.loginButton.isHidden = true
        self.forgotPasswordButton.isHidden = true
        self.viewDemoButton.isHidden = true
    }
    
    
    func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.userTextField.isHidden = false
            self.userBottomBorderView.isHidden = false
            self.passwordTextField.isHidden = false
            self.passwordBottomBorderView.isHidden = false
            self.loginButton.isHidden = false
            self.forgotPasswordButton.isHidden = false
            self.viewDemoButton.isHidden = false
            
            let anAnimationDuration :CFTimeInterval = 0.5
            
            self.userTextField.layer.add(Utilities.animation(self.userTextField, type: AnimationType.leftToRight, length: 300.0, duration: anAnimationDuration, fdTag: "userTextFieldAnimationTag", delegate: nil), forKey: "position")
            self.userBottomBorderView.layer.add(Utilities.animation(self.userBottomBorderView, type: AnimationType.rightToLeft, length: 300.0, duration: anAnimationDuration, fdTag: "userBottomBorderViewAnimationTag", delegate: nil), forKey: "position")
            
            self.passwordTextField.layer.add(Utilities.animation(self.passwordTextField, type: AnimationType.leftToRight, length: 300.0, duration: anAnimationDuration, fdTag: "passwordTextFieldAnimationTag", delegate: nil), forKey: "position")
            self.passwordBottomBorderView.layer.add(Utilities.animation(self.passwordBottomBorderView, type: AnimationType.rightToLeft, length: 300.0, duration: anAnimationDuration, fdTag: "passwordBottomBorderViewAnimationTag", delegate: nil), forKey: "position")
            
            self.loginButton.layer.add(Utilities.animation(self.loginButton, type: AnimationType.bottomToTop, length: 300.0, duration: anAnimationDuration, fdTag: "loginButtonAnimationTag", delegate: nil), forKey: "position")
            self.forgotPasswordButton.layer.add(Utilities.animation(self.forgotPasswordButton, type: AnimationType.bottomToTop, length: 300.0, duration: anAnimationDuration, fdTag: "forgotPasswordButtonAnimationTag", delegate: nil), forKey: "position")
            self.viewDemoButton.layer.add(Utilities.animation(self.viewDemoButton, type: AnimationType.bottomToTop, length: 300.0, duration: anAnimationDuration, fdTag: "viewDemoButtonAnimationTag", delegate: nil), forKey: "position")
        }
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
        DataAdapterFactory.sharedDataAdapter.login(aUser, completion: {(pDataAdapterResult) in
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
