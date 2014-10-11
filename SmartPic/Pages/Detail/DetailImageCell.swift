//
//  DetailImageCell.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/11.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

protocol DetailImageCellDelegate {
    func tapPickButton() -> Void
    func tapUnpickButton() -> Void
}

class DetailImageCell: UICollectionViewCell {
    
    var delegate: DetailImageCellDelegate!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var unpickButton: UIButton!
    @IBOutlet weak var verticalSpaceConstraint: NSLayoutConstraint!
    
    @IBAction func tapPickButton(sender: AnyObject) {
        verticalSpaceConstraint.constant = 0
        delegate.tapPickButton()
    }
    
    @IBAction func tapUnpickButton(sender: AnyObject) {
        verticalSpaceConstraint.constant = 40
        delegate.tapUnpickButton()
    }
}
