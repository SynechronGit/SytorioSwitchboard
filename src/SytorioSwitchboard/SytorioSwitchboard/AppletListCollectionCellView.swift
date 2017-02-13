//
//  AppletListCollectionCellView.swift
//  SytorioSwitchboard
//
//  Created by Rupendra on 03/02/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import ATKit


class AppletListCollectionCellView: UICollectionViewCell {
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var bottomContainer: UIView!
    
    @IBOutlet weak var appletTitleLabel: UILabel!
    @IBOutlet weak var appletDescriptionLabel: ATLabel!
    
    @IBOutlet weak var appletStateButton: UIButton!
    @IBOutlet weak var appletStateLabel: UILabel!
    
    weak var delegate :AppletListCollectionCellViewDelegate?
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        self.layer.cornerRadius = 8.0
        
        self.appletDescriptionLabel.verticalTextAlignment = ATVerticalTextAlignment.top
    }
    
    
    func loadApplet(_ pApplet :Applet) {
        self.appletTitleLabel.text = pApplet.title
        self.appletDescriptionLabel.text = pApplet.descriptionText
        
        if pApplet.triggerType == AppletTriggerType.email {
            self.topContainer.backgroundColor = UIColor(hexString: "275d8b") // Dark blue
        } else if pApplet.triggerType == AppletTriggerType.file {
            self.topContainer.backgroundColor = UIColor(hexString: "28872b") // Green
        } else {
            self.topContainer.backgroundColor = UIColor(hexString: "1a8797") // Light blue
        }
        self.appletTitleLabel.backgroundColor = self.topContainer.backgroundColor
        self.appletDescriptionLabel.backgroundColor = self.topContainer.backgroundColor
        self.bottomContainer.backgroundColor = UIColor(hexString: "FFFFFF")
        if pApplet.state == AppletState.running {
            self.appletStateButton.setImage(UIImage(named: "StartAppletButtonGreen")!, for: UIControlState.normal)
            self.appletStateLabel.textColor = UIColor(red: 51.0/255.0, green: 186.0/255.0, blue: 106.0/255.0, alpha: 1.0)
            self.appletStateLabel.text = "Running"
        } else if pApplet.state == AppletState.notRunning {
            self.appletStateButton.setImage(UIImage(named: "StartAppletButtonYellow")!, for: UIControlState.normal)
            self.appletStateLabel.textColor = UIColor(red: 239.0/255.0, green: 184.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            self.appletStateLabel.text = "Not Running"
        } else {
            self.appletStateButton.setImage(UIImage(named: "StartAppletButtonRed")!, for: UIControlState.normal)
            self.appletStateLabel.textColor = UIColor(red: 212.0/255.0, green: 54.0/255.0, blue: 60.0/255.0, alpha: 1.0)
            self.appletStateLabel.text = "Failed"
        }
    }
    
    
    @IBAction func didSelectStartAppletButton(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.appletListCollectionCellViewDidSelectStartAppletButton(self)
        }
    }
}


@objc protocol AppletListCollectionCellViewDelegate {
    func appletListCollectionCellViewDidSelectStartAppletButton(_ pSender: AppletListCollectionCellView)
}
