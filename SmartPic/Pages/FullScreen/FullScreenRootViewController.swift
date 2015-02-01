//
//  FullScreenRootViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2015/01/31.
//  Copyright (c) 2015年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class FullScreenRootViewController: GAITrackedViewController {
    
    var assets: [PHAsset]!
    var currentIndex: Int = -1
    var pageViewController: FullScreenPageViewController!
    
    private let photoFetcher = PhotoFetcher()
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "フルスクリーンルート"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedFullScreenPage" {
            pageViewController = segue.destinationViewController as FullScreenPageViewController
            pageViewController.currentIndex = currentIndex
            pageViewController.assets = assets
        }
    }
    
    @IBAction func tapBinButton(sender: AnyObject) {
        let delCount: Int = 1
        let asset = assets[pageViewController.currentIndex]
        photoFetcher.deleteImageAssets([asset],
            completionHandler: { (success, error) -> Void in
                if error != nil {
                    println("error occured. error is \(error!)")
                }
                else {
                    if success {
                        let tracker = GAI.sharedInstance().defaultTracker;
                        tracker.send(GAIDictionaryBuilder.createEventWithCategory("ui_action", action: "delete image", label: "single", value: delCount).build())
                        
                        // 削除した画像のID、残した画像のIDを記憶しておく
                        let delManager = DeleteManager.getInstance()
                        delManager.saveDeletedAssets([asset], arrangedAssets: [])
                        
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
}
