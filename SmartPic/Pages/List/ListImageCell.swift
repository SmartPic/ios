//
//  ListImageCell.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/06.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class ListImageCell: UICollectionViewCell {
    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var photosLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        listImageView.contentMode = .ScaleAspectFill
        photosLabel.text = NSLocalizedString("photos", comment: "")
    }
}
