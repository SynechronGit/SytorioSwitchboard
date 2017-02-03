//
//  AppletListController.swift
//  SytorioSwitchboard
//
//  Created by rupendra on 1/30/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit


class AppletListController: BaseController, UICollectionViewDataSource, UICollectionViewDelegate {
    var applets :Array<Applet>!
    
    @IBOutlet weak var runningAppletCountLabel: UILabel!
    @IBOutlet weak var notRunningAppletCountLabel: UILabel!
    @IBOutlet weak var failedAppletCountLabel: UILabel!
    
    @IBOutlet weak var appletListCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "LoginBanner")!)
        self.appletListCollectionView.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        let aPadding :CGFloat = 15.0
        let aCellWidth = (self.appletListCollectionView.frame.size.width / 2.0) - (aPadding * 4)
        let aCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        aCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: aPadding, left: aPadding, bottom: aPadding, right: aPadding)
        aCollectionViewFlowLayout.itemSize = CGSize(width: aCellWidth, height: aCellWidth)
        aCollectionViewFlowLayout.minimumInteritemSpacing = aPadding / 2.0
        aCollectionViewFlowLayout.minimumLineSpacing = aPadding / 2.0
        self.appletListCollectionView.collectionViewLayout = aCollectionViewFlowLayout
        
        self.reloadAllData()
    }
    
    
    override func viewWillAppear(_ pAnimated: Bool) {
        super.viewWillAppear(pAnimated)
        
        self.navigationController?.isNavigationBarHidden = false
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
            self.runningAppletCountLabel.text = String(format: "%02d", aRunningAppletCount)
            self.notRunningAppletCountLabel.text = String(format: "%02d", aNotRunningAppletCount)
            self.failedAppletCountLabel.text = String(format: "%02d", aFailedAppletCount)
            
            self.appletListCollectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var aReturnVal :Int = 0
        
        if self.applets != nil {
            aReturnVal = self.applets.count
        }
        
        return aReturnVal
    }
    
    
    func collectionView(_ pCollectionView: UICollectionView, cellForItemAt pIndexPath: IndexPath) -> UICollectionViewCell {
        let aReturnVal :AppletListCollectionCellView! = pCollectionView.dequeueReusableCell(withReuseIdentifier: "AppletCollectionCellReuseId", for: pIndexPath) as! AppletListCollectionCellView
        
        if self.applets != nil {
            let anApplet = self.applets[pIndexPath.row]
            
            aReturnVal.appletTitleLabel.text = anApplet.title
        }
        
        return aReturnVal
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
