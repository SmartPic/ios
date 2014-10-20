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
    
    var isPicked: Bool = false {
        didSet {
            verticalSpaceConstraint.constant = isPicked ? 0 : 40
        }
    }
    
    func setSelected(selected: Bool) {
        pickButton.hidden = !selected
        unpickButton.hidden = !selected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickButton.enabled = true
        unpickButton.enabled = false
        imageView.contentMode = .ScaleAspectFill
    }
    
    @IBAction func tapPickButton(sender: AnyObject) {
        isPicked = true
        pickButton.enabled = false
        unpickButton.enabled = true
        delegate?.tapPickButton(myIndex)
    }
    
    @IBAction func tapUnpickButton(sender: AnyObject) {
        isPicked = false
        pickButton.enabled = true
        unpickButton.enabled = false
        delegate?.tapUnpickButton(myIndex)
    }
}
