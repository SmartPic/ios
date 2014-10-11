//
//  DetailImageCell.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/11.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class DetailImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var unpickButton: UIButton!
    @IBOutlet weak var verticalSpaceConstraint: NSLayoutConstraint!
    
    @IBAction func tapPickButton(sender: AnyObject) {
        verticalSpaceConstraint.constant = 0
    }
    
    @IBAction func tapUnpickButton(sender: AnyObject) {
        verticalSpaceConstraint.constant = 40
    }
}
