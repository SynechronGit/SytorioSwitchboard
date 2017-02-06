//
//  AppletListCollectionCellView.swift
//  SytorioSwitchboard
//
//  Created by Rupendra on 03/02/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit


class AppletListCollectionCellView: UICollectionViewCell {
    @IBOutlet weak var appletTitleLabel: UILabel!
    @IBOutlet weak var appletDescriptionLabel: UILabel!
    
    weak var delegate :AppletListCollectionCellViewDelegate?
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
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
