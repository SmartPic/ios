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
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var noneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    
    var isShareMode = false
    var delegate: PromoteViewDelegate?
    
    class func view() -> PromoteView {
        let bundle = NSBundle.mainBundle()
        let views = bundle.loadNibNamed("PromoteView", owner: nil, options: nil)
        return views.first! as PromoteView
    }
    
    class func showPromoteAlert(isShareMode: Bool = false) {
        let view = self.view()
        
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
    }
    
    func setUpShareMode(score:Int) {
        isShareMode = true
        
        actionButton.setTitle("シェアする", forState: .Normal)
        titleLabel.text = "おめでとうございます！\n\(score) 枚の写真を削除しました！"
        detailTextLabel.text = "ALPACAでのこれまでの成果を\n友達にシェアしませんパカ？"
    }
    
    @IBAction func reviewBtnTouched(sender: AnyObject) {
        
        if isShareMode {
            delegate?.didTapShareStatusButton()
        }
        else {
            let reviewManager = ReviewManager.getInstance()
            reviewManager.checkReviewDone()
            
            let url = NSURL(string: kAppStoreUrl)
            if UIApplication.sharedApplication().canOpenURL(url!) {
                UIApplication.sharedApplication().openURL(url!)
            }
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: nil,
            animations: { () -> Void in
                self.alpha = 0.0
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }

    @IBAction func laterBtnTouched(sender: AnyObject) {
        
        if !isShareMode {
            let reviewManager = ReviewManager.getInstance()
            reviewManager.resetDeleteCount()
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: nil,
            animations: { () -> Void in
                self.alpha = 0.0
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
    }
    
}
