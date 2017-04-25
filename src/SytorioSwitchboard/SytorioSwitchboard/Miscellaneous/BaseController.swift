//
//  BaseController.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit

let kTopBarButtonHeightWidth :CGFloat = 30.0

class BaseController: UIViewController, ATDrawerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.view.backgroundColor = self.navigationController?.navigationBar.backgroundColor
        
        
        self.navBarRightButtonImage = UIImage(named: "HamburgerMenu")
    }
    
    
    func logout() {
        GlobalData.loggedInUser = nil
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    /**
     * Variable that will set left button image on top bar.
     */
    private var _navBarLeftButtonImage: UIImage!
    var navBarLeftButtonImage: UIImage! {
        get {
            return _navBarLeftButtonImage
        }
        set {
            _navBarLeftButtonImage = newValue
            if _navBarLeftButtonImage != nil && _navBarLeftButtonImage.isKind(of: UIImage.self) {
                self.navigationItem.hidesBackButton = true
                let aButton: UIButton = UIButton(type: UIButtonType.custom) as UIButton
                aButton.frame = CGRect(x: 0.0, y: 0.0, width: kTopBarButtonHeightWidth, height: kTopBarButtonHeightWidth)
                aButton.setImage(_navBarLeftButtonImage, for: UIControlState.normal)
                aButton.imageView?.contentMode = .scaleAspectFit
                aButton.contentEdgeInsets = UIEdgeInsets(top: 7.0, left: 0.0, bottom: 0.0, right: 0.0)
                aButton.addTarget(self, action: #selector(BaseController.didSelectNavBarLeftButton(sender:)), for: UIControlEvents.touchUpInside)
                let aLeftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: aButton)
                self.navigationItem.setLeftBarButton(aLeftBarButtonItem, animated: false)
            } else if self.navigationItem.leftBarButtonItem != nil {
                self.navigationItem.hidesBackButton = false
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    
    /**
     * Variable that will be called when left button on top bar is tapped.
     */
    func didSelectNavBarLeftButton(sender:UIButton!) {
        
    }
    
    
    /**
     * Variable that will set right button image on top bar.
     */
    private var _navBarRightButtonImage: UIImage!
    var navBarRightButtonImage: UIImage! {
        get {
            return _navBarRightButtonImage
        }
        set {
            _navBarRightButtonImage = newValue
            if _navBarRightButtonImage != nil && _navBarRightButtonImage.isKind(of: UIImage.self) {
                let aButton: UIButton = UIButton(type: UIButtonType.custom) as UIButton
                aButton.frame = CGRect(x: 0.0, y: 0.0, width: kTopBarButtonHeightWidth, height: kTopBarButtonHeightWidth)
                aButton.setImage(_navBarRightButtonImage, for: UIControlState.normal)
                aButton.imageView?.contentMode = .scaleAspectFit
                aButton.contentEdgeInsets = UIEdgeInsets(top: 7.0, left: 0.0, bottom: 0.0, right: 0.0)
                aButton.addTarget(self, action: #selector(BaseController.didSelectNavBarRightButton(sender:)), for: UIControlEvents.touchUpInside)
                let aRightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: aButton)
                self.navigationItem.setRightBarButton(aRightBarButtonItem, animated: false)
            } else if self.navigationItem.rightBarButtonItem != nil {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    
    /**
     * Variable that will be called when right button on top bar is tapped.
     */
    func didSelectNavBarRightButton(sender:UIButton!) {
        ATDrawer.sharedInstance.drawerOptions = ["Logout"]
        ATDrawer.sharedInstance.delegate = self
        ATDrawer.sharedInstance.slideDirection = ATDrawerSlideDirection.rightToLeft
        ATDrawer.sharedInstance.show()
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
    
    
    // MARK: - ATDrawer Methods
    
    @IBAction func didSelectSelectHideDrawerButton(_ sender: AnyObject) {
        ATDrawer.sharedInstance.hide()
    }
    
    
    func atDrawer(_ pSender: ATDrawer, didSelectOptionAtIndex pIndex: Int) {
        if pIndex == 0 {
            self.logout()
        }
    }
    
}

