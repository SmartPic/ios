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
    
    override func awakeFromNib() {
        listImageView.contentMode = .ScaleAspectFill
    }
}
