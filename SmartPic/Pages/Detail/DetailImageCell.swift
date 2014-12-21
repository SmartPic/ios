//
//  DetailImageCell.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/11.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class DetailImageCell: UICollectionViewCell {
    var myIndex: Int = 0
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedMaskImageView: UIImageView!
    @IBOutlet weak var staredMaskImageView: UIImageView!
    
    var isPicked: Bool = false {
        didSet {
            staredMaskImageView.hidden = !isPicked
        }
    }
    
    func setSelected(selected: Bool) {
        selectedMaskImageView.hidden = !selected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedMaskImageView.hidden = true
        staredMaskImageView.hidden = true
    }
}
