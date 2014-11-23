//
//  StatusMusicCell.swift
//  SmartPic
//
//  Created by himara2 on 2014/11/23.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class StatusMusicCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero

        titleLabel.text = NSLocalizedString("It's as big as", comment: "")
        unitLabel.text = NSLocalizedString("music files", comment: "")
    }

}
