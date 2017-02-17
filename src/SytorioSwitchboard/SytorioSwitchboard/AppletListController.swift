//
//  AppletListController.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit

class AppletListController: BaseController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AppletListCollectionCellViewDelegate {
    
    var applets :Array<Applet>!
    var filteredApplets: Array<Applet>!
    var selectedAppletState:AppletState!
    
    @IBOutlet weak var runningAppletCountLabel: UILabel!
    @IBOutlet weak var runningAppletProgressView: UIProgressView!
    @IBOutlet weak var notRunningAppletCountLabel: UILabel!
    @IBOutlet weak var notRunningAppletProgressView: UIProgressView!
    @IBOutlet weak var failedAppletCountLabel: UILabel!
    @IBOutlet weak var failedAppletProgressView: UIProgressView!
    
    @IBOutlet weak var appletListCollectionView: UICollectionView!
    
    @IBOutlet weak var runningAppletCountContainerView: UIView!
    @IBOutlet weak var notRunningAppletCountContainerView: UIView!
    @IBOutlet weak var failedAppletCountContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appletListCollectionView.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        let aPadding :CGFloat = 15.0
        let aCellWidth = (self.appletListCollectionView.frame.size.width / 2.0) - (aPadding * 4)
        let aCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        aCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: aPadding, left: aPadding, bottom: aPadding, right: aPadding)
        aCollectionViewFlowLayout.itemSize = CGSize(width: aCellWidth, height: aCellWidth)
        aCollectionViewFlowLayout.minimumInteritemSpacing = aPadding / 2.0
        aCollectionViewFlowLayout.minimumLineSpacing = aPadding / 2.0
        self.appletListCollectionView.collectionViewLayout = aCollectionViewFlowLayout
        
        let runningAppletTapGesture = UITapGestureRecognizer(target: self, action: #selector(AppletListController.displayRunningApplets))
        runningAppletCountContainerView.addGestureRecognizer(runningAppletTapGesture)
        
        let notRunningAppletTapGesture = UITapGestureRecognizer(target: self, action: #selector(AppletListController.displayNotRunningApplets))
        notRunningAppletCountContainerView.addGestureRecognizer(notRunningAppletTapGesture)
        
        let failedAppletTapGesture = UITapGestureRecognizer(target: self, action: #selector(AppletListController.displayFailedApplets))
        failedAppletCountContainerView.addGestureRecognizer(failedAppletTapGesture)
        
    }
    
    
    override func viewWillAppear(_ pAnimated: Bool) {
        super.viewWillAppear(pAnimated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.navBarLeftButtonImage = UIImage(named: "TopBarLogo")
    }
    
    
    override func viewDidAppear(_ pAnimated: Bool) {
        super.viewDidAppear(pAnimated)
        
        self.reloadAllData()
    }
    
    
    func reloadAllData() {
        ATOverlay.sharedInstance.show()
        DataAdapterFactory.sharedDataAdapter.fetchAppletList(completion: {(pDataAdapterResult) in
            ATOverlay.sharedInstance.hide()
            self.dataAdapterDidExecuteRequest(type: DataAdapterRequestType.fetchAppletList, result: pDataAdapterResult)
        })
    }
    
    
    func reloadAllView() {
        if self.applets != nil {
            var aRunningAppletCount = 0
            var aNotRunningAppletCount = 0
            var aFailedAppletCount = 0
            
            self.filteredApplets = Array<Applet>()
            
            for anApplet in self.applets {
                
                if anApplet.state == AppletState.running {
                    aRunningAppletCount = aRunningAppletCount + 1
                    if self.selectedAppletState == AppletState.running {
                        self.filteredApplets.append(anApplet)
                    }
                    
                } else if anApplet.state == AppletState.notRunning {
                    aNotRunningAppletCount = aNotRunningAppletCount + 1
                    if self.selectedAppletState == AppletState.notRunning {
                        self.filteredApplets.append(anApplet)
                    }
                    
                } else if anApplet.state == AppletState.failed {
                    aFailedAppletCount = aFailedAppletCount + 1
                    if self.selectedAppletState == AppletState.failed {
                        self.filteredApplets.append(anApplet)
                    }
                }
            }
            
            self.runningAppletCountLabel.text = String(format: "%02d", aRunningAppletCount)
            self.runningAppletProgressView.progress = Float(aRunningAppletCount) / Float(self.applets.count)
            
            self.notRunningAppletCountLabel.text = String(format: "%02d", aNotRunningAppletCount)
            self.notRunningAppletProgressView.progress = Float(aNotRunningAppletCount) / Float(self.applets.count)
            
            self.failedAppletCountLabel.text = String(format: "%02d", aFailedAppletCount)
            self.failedAppletProgressView.progress = Float(aFailedAppletCount) / Float(self.applets.count)
            
            if self.selectedAppletState == nil {
                self.filteredApplets = self.applets
            }
            
            self.appletListCollectionView.reloadData()
        }
    }
    
    
    func displayRunningApplets() {
    
        self.selectedAppletState = AppletState.running
        self.reloadAllView()
    }
    
    
    func displayNotRunningApplets() {
        
        self.selectedAppletState = AppletState.notRunning
        self.reloadAllView()
    }
    
    
    func displayFailedApplets() {
        
        self.selectedAppletState = AppletState.failed
        self.reloadAllView()
    }
    
    
    // MARK: - AppletListCollectionCellViewDelegate Methods
    
    func appletListCollectionCellViewDidSelectStartAppletButton(_ pSender: AppletListCollectionCellView) {
        let anIndexPath = self.appletListCollectionView.indexPath(for: pSender)
        if anIndexPath != nil && self.filteredApplets != nil && self.filteredApplets.count > (anIndexPath?.row)! {
            let anApplet = self.filteredApplets[(anIndexPath?.row)!]
            if anApplet.isOn == true {
                anApplet.isOn = false
            } else {
                anApplet.isOn = true
            }
            ATOverlay.sharedInstance.show()
            DataAdapterFactory.sharedDataAdapter.updateApplet(anApplet, completion: {(pDataAdapterResult) in
                ATOverlay.sharedInstance.hide()
                self.dataAdapterDidExecuteRequest(type: DataAdapterRequestType.updateApplet, result: pDataAdapterResult)
            })
        }
    }
    
    
    // MARK: - UICollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var aReturnVal :Int = 0
        
        if self.filteredApplets != nil {
            aReturnVal = self.filteredApplets.count
        }
        
        return aReturnVal
    }
    
    
    func collectionView(_ pCollectionView: UICollectionView, cellForItemAt pIndexPath: IndexPath) -> UICollectionViewCell {
        let aReturnVal :AppletListCollectionCellView! = pCollectionView.dequeueReusableCell(withReuseIdentifier: "AppletCollectionCellReuseId", for: pIndexPath) as! AppletListCollectionCellView
        
        if self.filteredApplets != nil {
            let anApplet = self.filteredApplets[pIndexPath.row]
            aReturnVal.loadApplet(anApplet)
            aReturnVal.delegate = self
        }
        
        return aReturnVal
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var aCellWidth = (self.appletListCollectionView.frame.size.width / 2.0) - (10 * 2)
        if aCellWidth > 170.0 {
            aCellWidth = 170.0
        }
        return CGSize(width: aCellWidth, height: aCellWidth)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
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
            } else if pRequestType == DataAdapterRequestType.updateApplet {
                self.reloadAllData()
            }
        } else {
            self.displayMessage(message: pResult.error.localizedDescription, type: MessageType.Error)
        }
    }
}
