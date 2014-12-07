//
//  PromoteView.swift
//  SmartPic
//
//  Created by himara2 on 2014/12/07.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

private let kAppStoreUrl = "https://itunes.apple.com/app/id934444072?mt=8"

class PromoteView: UIView {

    @IBOutlet weak var baseView: UIView!
    
    class func view() -> PromoteView {
        let bundle = NSBundle.mainBundle()
        let views = bundle.loadNibNamed("PromoteView", owner: nil, options: nil)
        return views.first! as PromoteView
    }
    
    class func showPromoteAlert() {
        let view = self.view()
        
        let window = UIApplication.sharedApplication().keyWindow
        window!.addSubview(view)
        
        view.frame = window!.frame
    }
    
    override func awakeFromNib() {
        baseView.layer.cornerRadius = 5.0
        baseView.layer.masksToBounds = true
    }
    
    @IBAction func reviewBtnTouched(sender: AnyObject) {
        let reviewManager = ReviewManager.getInstance()
        reviewManager.checkReviewDone()
        
        let url = NSURL(string: kAppStoreUrl)
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: nil,
            animations: { () -> Void in
                self.alpha = 0.0
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }

    @IBAction func laterBtnTouched(sender: AnyObject) {
        let reviewManager = ReviewManager.getInstance()
        reviewManager.resetDeleteCount()
        
        UIView.animateWithDuration(0.2, delay: 0, options: nil,
            animations: { () -> Void in
                self.alpha = 0.0
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
    }
    
}
