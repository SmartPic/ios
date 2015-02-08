//
//  FullScreenViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/12/17.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class FullScreenViewController: GAITrackedViewController, UIScrollViewDelegate {
    
    var asset: PHAsset!
    private let photoFetcher = PhotoFetcher()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewHeightConstrraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageViewWidthConstraint.constant = self.view.frame.size.width
        imageViewHeightConstrraint.constant = self.view.frame.size.height
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.zoomScale = 1
        self.screenName = "フルスクリーンビュー"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "unwindFullScreen") {
            let listViewController:ListViewController = segue.destinationViewController as ListViewController
            listViewController.latestDeletedCount = sender as Int
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func tapImageView() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
