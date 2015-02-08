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
    @IBOutlet weak var selectedView: UIImageView!
    
    var isSelected: Bool = false {
        didSet {
            selectedView.hidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        selectedView.hidden = true
        
        let device = UIDevice().segmentName()
        if (device == "iPhone6") {
            selectedView.image = UIImage(named: "selected_6")
        } else if (device == "iPhone6 Plus") {
            selectedView.image = UIImage(named: "selected_6plus")
        } else {
            selectedView.image = UIImage(named: "selected_5")
        }
    }
    
}


