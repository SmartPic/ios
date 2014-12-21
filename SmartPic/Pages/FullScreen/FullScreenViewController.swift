//
//  FullScreenViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/12/17.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class FullScreenViewController: UIViewController, UIScrollViewDelegate {
    
    var asset: PHAsset!
    private let photoFetcher = PhotoFetcher()
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        photoFetcher.requestImageForAsset(asset,
            size: imageView.frame.size) { (image, info) -> Void in
                if (image === nil) { return }
                self.imageView.image = image
        }
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapImageView")
        imageView.addGestureRecognizer(gestureRecognizer)
        
        imageViewWidthConstraint.constant = self.view.frame.size.width
        imageViewHeightConstraint.constant = self.view.frame.size.height
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func tapBinButton(sender: AnyObject) {
        var delCount: Int = 1
        photoFetcher.deleteImageAssets([asset],
            completionHandler: { (success, error) -> Void in
                if error != nil {
                    println("error occured. error is \(error!)")
                }
                else {
                    if success {
                        let tracker = GAI.sharedInstance().defaultTracker;
                        tracker.send(GAIDictionaryBuilder.createEventWithCategory("ui_action", action: "delete image", label: "fullscreen", value: delCount).build())
                        
                        // 削除した画像のID、残した画像のIDを記憶しておく
                        let delManager = DeleteManager.getInstance()
                        delManager.saveDeletedAssets([self.asset], arrangedAssets: [])
                        
                        // レビューアラート用の表示
                        let reviewManager = ReviewManager.getInstance()
                        reviewManager.addDeleteCount(delCount)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            // 解決法
                            // http://stackoverflow.com/questions/24296023/animatewithdurationanimationscompletion-in-swift/24297018#24297018
                            _ in self.performSegueWithIdentifier("unwindFullScreen", sender: delCount); return ()
                        })
                    }
                    else {
                        println("delete failed..")
                    }
                }
        })
    }
    
    func tapImageView() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
