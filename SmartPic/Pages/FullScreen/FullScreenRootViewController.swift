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
            let viewController:FullScreenPageViewController = segue.destinationViewController as FullScreenPageViewController
            viewController.assets = assets
        }
    }
}
