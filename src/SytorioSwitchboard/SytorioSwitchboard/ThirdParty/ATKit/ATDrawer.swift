//
//  ATDrawer.swift
//  ATKit
//
//  Created by Rupendra on 01/09/16.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit


@objc public protocol ATDrawerDelegate :NSObjectProtocol {
    @objc optional func atDrawer(_ pSender:ATDrawer, didSelectOptionAtIndex pIndex: Int)
}


public enum ATDrawerSlideDirection :Int {
    case leftToRight
    case rightToLeft
}


open class ATDrawer: NSObject, UITableViewDataSource, UITableViewDelegate {
    private static var __once: () = {
            _sharedInstance = ATDrawer()
        }()
    static var dispatchOnceToken: Int = 0
    static var _sharedInstance: ATDrawer? = nil
    
    private var drawerWidth :CGFloat = 200.0
    private var drawerSlideDuration :TimeInterval = 0.3
    private var drawerWindow :UIWindow!
    private var drawerView :UIView!
    open var drawerOptions :Array<String>!
    open var slideDirection :ATDrawerSlideDirection = ATDrawerSlideDirection.rightToLeft
    open var selectedDrawerOptionIndex :Int!
    private var drawerTableView: UITableView!
    weak private var currentKeyWindow :UIWindow!
    
    weak open var delegate :ATDrawerDelegate!
    private var shouldCallDidSelectOption :Bool = false
    
    
    open static var sharedInstance: ATDrawer {
        _ = ATDrawer.__once
        return _sharedInstance!
    }
    
    
    override init() {
        super.init()
        self.initializeAllView()
    }
    
    
    private func initializeAllView() {
        if self.drawerWindow == nil {
            self.drawerWindow = UIWindow()
            self.drawerWindow.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.drawerWindow.backgroundColor = UIColor.clear
            self.drawerWindow.windowLevel = UIWindowLevelNormal
            let aTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ATDrawer.didTapWindow(_:)))
            aTapGestureRecognizer.cancelsTouchesInView = false
            self.drawerWindow.addGestureRecognizer(aTapGestureRecognizer)
            
            self.drawerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.drawerWidth, height: 100.0))
            self.drawerView.backgroundColor = UIColor.clear
            self.drawerView.layer.shadowOffset = CGSize(width: -3, height: 0)
            self.drawerView.layer.shadowOpacity = 0.5
            self.drawerView.layer.shadowRadius = 2
            self.drawerWindow.addSubview(self.drawerView)
            self.drawerView.translatesAutoresizingMaskIntoConstraints = false
            self.drawerWindow.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String(format: "H:[drawerView(%d)]|", Int(self.drawerWidth)), options: [], metrics: nil, views: ["drawerView":self.drawerView]))
            self.drawerWindow.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[drawerView]|", options: [], metrics: nil, views: ["drawerView":self.drawerView]))
            
            let aDrawerBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight))
            aDrawerBackgroundView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.drawerView.addSubview(aDrawerBackgroundView)
            aDrawerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            self.drawerWindow.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[aDrawerBackgroundView]|", options: [], metrics: nil, views: ["aDrawerBackgroundView":aDrawerBackgroundView]))
            self.drawerWindow.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[aDrawerBackgroundView]|", options: [], metrics: nil, views: ["aDrawerBackgroundView":aDrawerBackgroundView]))
            
            self.drawerTableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
            self.drawerTableView.backgroundColor = UIColor.clear
            self.drawerTableView.dataSource = self
            self.drawerTableView.delegate = self
            self.drawerTableView.tableFooterView = UIView()
            self.drawerView.addSubview(self.drawerTableView)
            self.drawerTableView.translatesAutoresizingMaskIntoConstraints = false
            self.drawerWindow.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[drawerTableView]|", options: [], metrics: nil, views: ["drawerTableView":self.drawerTableView]))
            self.drawerWindow.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[drawerTableView]|", options: [], metrics: nil, views: ["drawerTableView":self.drawerTableView]))
        }
    }
    
    
    private func reloadAllView() {
        if self.drawerWindow != nil {
            // Take frame of app window, as this is the window that should be overlayed.
            let anAppWindow :UIWindow = ((UIApplication.shared.delegate?.window)!)!
            self.drawerWindow.frame = CGRect(x: 0.0, y: 0.0, width: anAppWindow.bounds.size.width, height: anAppWindow.bounds.size.height)
        }
        self.drawerWindow.layoutIfNeeded()
        
        self.drawerTableView.reloadData()
    }
    
    
    open func show() {
        if self.currentKeyWindow == nil {
            self.currentKeyWindow = UIApplication.shared.keyWindow
        }
        
        if self.drawerWindow != nil {
            self.drawerWindow.makeKeyAndVisible()
            self.reloadAllView()
            
            if self.selectedDrawerOptionIndex != nil {
                self.drawerTableView.selectRow(at: IndexPath(row: self.selectedDrawerOptionIndex, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
            }
            
            var aTrailingConstraint :NSLayoutConstraint! = nil
            for aConstraint in self.drawerWindow.constraints {
                if self.drawerView.isEqual(aConstraint.secondItem) && aConstraint.firstAttribute == NSLayoutAttribute.trailing {
                    aTrailingConstraint = aConstraint
                    break
                }
            }
            if self.slideDirection == ATDrawerSlideDirection.leftToRight {
                if aTrailingConstraint != nil {
                    self.drawerView.layer.shadowOffset = CGSize(width: 3, height: 0)
                    self.drawerView.layer.shadowOpacity = 0.5
                    aTrailingConstraint.constant = self.drawerWindow.frame.size.width
                    self.drawerWindow.layoutIfNeeded()
                    aTrailingConstraint.constant = self.drawerWindow.frame.size.width - self.drawerView.frame.size.width
                    UIView.animate(withDuration: self.drawerSlideDuration, animations: {
                        self.drawerWindow.layoutIfNeeded()
                    })
                }
            } else {
                if aTrailingConstraint != nil {
                    self.drawerView.layer.shadowOpacity = 0.5
                    aTrailingConstraint.constant = -self.drawerView.frame.size.width
                    self.drawerWindow.layoutIfNeeded()
                    aTrailingConstraint.constant = 0
                    UIView.animate(withDuration: self.drawerSlideDuration, animations: {
                        self.drawerWindow.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    
    open func hide() {
        if self.drawerWindow != nil {
            var aTrailingConstraint :NSLayoutConstraint! = nil
            for aConstraint in self.drawerWindow.constraints {
                if self.drawerView.isEqual(aConstraint.secondItem) && aConstraint.firstAttribute == NSLayoutAttribute.trailing {
                    aTrailingConstraint = aConstraint
                    break
                }
            }
            if self.slideDirection == ATDrawerSlideDirection.leftToRight {
                if aTrailingConstraint != nil {
                    aTrailingConstraint.constant = self.drawerWindow.frame.size.width
                }
            } else {
                if aTrailingConstraint != nil {
                    aTrailingConstraint.constant = -self.drawerView.frame.size.width
                }
            }
            
            UIView.animate(withDuration: self.drawerSlideDuration, animations: {
                self.drawerWindow.layoutIfNeeded()
            }, completion: {(value: Bool) in
                self.drawerView.layer.shadowOpacity = 0.0
                if self.currentKeyWindow != nil {
                    self.currentKeyWindow.makeKeyAndVisible()
                    self.currentKeyWindow = nil
                }
                if self.shouldCallDidSelectOption {
                    self.delegate.atDrawer?(self, didSelectOptionAtIndex: self.selectedDrawerOptionIndex)
                    self.shouldCallDidSelectOption = false
                }
            })
        }
    }
    
    
    internal func didTapWindow(_ pSender:UITapGestureRecognizer) {
        let aLocation = pSender.location(ofTouch: 0, in: self.drawerWindow)
        let aTappedView :UIView! = self.drawerWindow?.hitTest(aLocation, with: nil)
        if aTappedView != nil && aTappedView.isEqual(self.drawerWindow) {
            self.hide()
        }
    }
    
    
    // MARK: - UITableView Methods
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var aReturnVal :Int = 0
        
        if self.drawerOptions != nil {
            aReturnVal = self.drawerOptions.count
        }
        
        return aReturnVal
    }
    
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aReturnVal :CGFloat = 44.0
        return aReturnVal
    }
    
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var aReturnVal:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "DrawerTableCellViewID")
        if aReturnVal == nil {
            aReturnVal = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "DrawerTableCellViewID")
        }
        aReturnVal.backgroundColor = UIColor.clear
        aReturnVal.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        aReturnVal.layoutMargins = UIEdgeInsets.zero
        aReturnVal.separatorInset = UIEdgeInsets.zero
        aReturnVal.preservesSuperviewLayoutMargins = false
        
        if self.drawerOptions != nil {
            aReturnVal.textLabel?.text = self.drawerOptions[(indexPath as NSIndexPath).row]
        }
        
        return aReturnVal
    }
    
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedDrawerOptionIndex = (indexPath as NSIndexPath).row
        self.shouldCallDidSelectOption = true
        self.hide()
    }
}
