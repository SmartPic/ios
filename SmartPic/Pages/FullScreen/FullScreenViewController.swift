//
//  FullScreenViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/12/17.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class FullScreenViewController: UIViewController {
    
    var asset: PHAsset!
    private let photoFetcher = PhotoFetcher()
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        photoFetcher.requestImageForAsset(asset,
            size: imageView.frame.size) { (image, info) -> Void in
                if (image === nil) { return }
                self.imageView.image = image
        }
    }
    
    // TODO: UIScrollView の関係で反応しない
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
