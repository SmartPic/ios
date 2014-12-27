//
//  PromoteView.swift
//  SmartPic
//
//  Created by himara2 on 2014/12/07.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

protocol PromoteViewDelegate {
    func didTapShareStatusButton() -> Void
}

class PromoteView: UIView {

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var actionButton: FlatButton!
    @IBOutlet weak var noneButton: FlatButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    
    var isShareMode = false
    var score: Int = 0
    var delegate: PromoteViewDelegate?
    
    class func view() -> PromoteView {
        let bundle = NSBundle.mainBundle()
        let views = bundle.loadNibNamed("PromoteView", owner: nil, options: nil)
        return views.first! as PromoteView
    }
    
    class func showPromoteReviewAlert() {
        let view = self.view()
        
        view.setUpReviewMode()
        let window = UIApplication.sharedApplication().keyWindow
        window!.addSubview(view)
        
        view.frame = window!.frame
    }
    
    class func showPromoteShareAlert(score: Int, delegate: PromoteViewDelegate) {
        let view = self.view()
        
        view.setUpShareMode(score)
        view.delegate = delegate
        
        let window = UIApplication.sharedApplication().keyWindow
        window!.addSubview(view)
        
        view.frame = window!.frame
    }
    
    override func awakeFromNib() {
        baseView.layer.cornerRadius = 5.0
        baseView.layer.masksToBounds = true
        
        actionButton.setTitleColor(UIColor.colorWithRGBHex(0x4d4949), forState: .Normal)
        actionButton.normalColor = UIColor.whiteColor()
        actionButton.highlightedColor = UIColor.colorWithRGBHex(0xdedede)
        actionButton.layer.borderColor = UIColor.colorWithRGBHex(0xe3d42e).CGColor
        actionButton.layer.borderWidth = 2.0
    }
    
    func setUpReviewMode() {
        isShareMode = false
        
        actionButton.setTitle(NSLocalizedString("Write review", comment:""), forState: .Normal)
        noneButton.setTitle(NSLocalizedString("Not now", comment:""), forState: .Normal)
        titleLabel.text = NSLocalizedString("Thank you for using ALPACA!", comment:"")
        detailTextLabel.text = NSLocalizedString("To add new free features, \nyour 5 star review will cheer us up", comment:"")
    }
    
    func setUpShareMode(score:Int) {
        isShareMode = true
        self.score = score
        
        actionButton.setTitle(NSLocalizedString("Share", comment:""), forState: .Normal)
        noneButton.setTitle(NSLocalizedString("Not now", comment:""), forState: .Normal)
        titleLabel.text =  String(format: NSLocalizedString("Congratulations! You've deleted %d photos!", comment:""), score)
        detailTextLabel.text = NSLocalizedString("Share the result of using ALPACA!", comment: "")
    }
    
    @IBAction func reviewBtnTouched(sender: AnyObject) {
        
        if isShareMode {
            delegate?.didTapShareStatusButton()
            
            let tracker = GAI.sharedInstance().defaultTracker;
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("archivement",
                action: "share",
                label: "promote",
                value: score).build())
            
        }
        else {
            let reviewManager = ReviewManager.getInstance()
            reviewManager.checkReviewDone()
            
            let url = NSURL(string: kAppStoreUrl)
            if UIApplication.sharedApplication().canOpenURL(url!) {
                UIApplication.sharedApplication().openURL(url!)
            }
            
            let tracker = GAI.sharedInstance().defaultTracker;
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("review",
                action: "review",
                label: "promote",
                value: 0).build())
        }
        
        removeViewWithAnimation()
    }

    @IBAction func laterBtnTouched(sender: AnyObject) {
        
        if isShareMode {
            let tracker = GAI.sharedInstance().defaultTracker;
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("archivement",
                action: "later",
                label: "promote",
                value: score).build())
        }
        else {
            let reviewManager = ReviewManager.getInstance()
            reviewManager.resetDeleteCount()
            
            let tracker = GAI.sharedInstance().defaultTracker;
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("review",
                action: "later",
                label: "promote",
                value: 0).build())
        }

        removeViewWithAnimation()
    }
    
    private func removeViewWithAnimation() {
        UIView.animateWithDuration(0.2, delay: 0, options: nil,
            animations: { () -> Void in
                self.alpha = 0.0
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
    }
    
}
