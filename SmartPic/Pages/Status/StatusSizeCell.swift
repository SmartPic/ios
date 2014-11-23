//
//  StatusSizeCell.swift
//  SmartPic
//
//  Created by himara2 on 2014/11/23.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class StatusSizeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero
        
        titleLabel.text = NSLocalizedString("Memory Freed", comment: "")
    }

}
