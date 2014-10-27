//
//  NoPictureView.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/27.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class NoPictureView: UIView {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        let className: String = "NoPictureView";
        NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        
        messageLabel.text = NSLocalizedString("NO_PICTURE_MESSAGE", comment:"")
        
        contentView.frame = bounds;
        self.addSubview(contentView)
    }
}
