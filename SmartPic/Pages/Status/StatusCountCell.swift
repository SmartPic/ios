//
//  StatusCountCell.swift
//  SmartPic
//
//  Created by himara2 on 2014/11/23.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class StatusCountCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero
        
        titleLabel.text = NSLocalizedString("ALPACA deleted", comment: "")
        unitLabel.text = NSLocalizedString("status_photos", comment: "")
    }

}
