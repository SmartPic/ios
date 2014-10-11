//
//  DetailImageCell.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/11.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

protocol DetailImageCellDelegate {
    func tapPickButton(myIndex: Int) -> Void
    func tapUnpickButton(myIndex: Int) -> Void
}

class DetailImageCell: UICollectionViewCell {
    
    var delegate: DetailImageCellDelegate?
    var myIndex: Int = 0
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var unpickButton: UIButton!
    @IBOutlet weak var verticalSpaceConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickButton.enabled = true
        unpickButton.enabled = false
    }
    
    @IBAction func tapPickButton(sender: AnyObject) {
        verticalSpaceConstraint.constant = 0
        pickButton.enabled = false
        unpickButton.enabled = true
        delegate?.tapPickButton(myIndex)
    }
    
    @IBAction func tapUnpickButton(sender: AnyObject) {
        verticalSpaceConstraint.constant = 40
        pickButton.enabled = true
        unpickButton.enabled = false
        delegate?.tapUnpickButton(myIndex)
    }
}
