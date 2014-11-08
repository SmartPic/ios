//
//  FlatButton.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/11/06.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class FlatButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 0.0
        self.setTitle(NSLocalizedString("Delete All", comment:""), forState: UIControlState.Normal)
//        saveButton.backgroundColor = UIColor.colorWithRGBHex(0xe3d42e)
    }
}
