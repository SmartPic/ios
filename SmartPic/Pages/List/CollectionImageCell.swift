//
//  CollectionImageCell.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/12/14.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class CollectionImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    
    var isSelected: Bool = false {
        didSet {
            selectedView.hidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        selectedView.hidden = true
    }
    
}


