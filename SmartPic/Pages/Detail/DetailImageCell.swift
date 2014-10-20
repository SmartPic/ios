//
//  DetailImageCell.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/11.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class DetailImageCell: UICollectionViewCell {
    
    @IBOutlet weak var maskImageView: UIImageView!
    var myIndex: Int = 0
    @IBOutlet weak var imageView: UIImageView!
    
    var isPicked: Bool = false {
        didSet {
            if (isPicked) {
                maskImageView.hidden = false
            }
            maskImageView.highlighted = isPicked
        }
    }
    
    func setSelected(selected: Bool) {
        if (isPicked) {
            maskImageView.hidden = false
            return;
        }
        maskImageView.hidden = !selected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        maskImageView.hidden = true
        imageView.contentMode = .ScaleAspectFill
    }
}
