//
//  FullScreenPageViewController.swift
//  SmartPic
//
//  Created by tanabe yuki on 2015/01/31.
//  Copyright (c) 2015年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class FullScreenPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var assets: [PHAsset] = [] {
        didSet {
            if (currentIndex == -1) { return }
            self.configureCurrentViewController()
        }
    }
    var currentIndex: Int = -1 {
        didSet {
            if (assets.count == 0) { return }
            self.configureCurrentViewController()
        }
    }
    
    private let photoFetcher = PhotoFetcher()
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(FullScreenViewController.className) as FullScreenViewController
        viewController.asset = assets[0]
        self.setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UIPageViewController
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    // MARK: Private methods
    
    private func viewControllerAtIndex(index: Int) -> FullScreenViewController {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(FullScreenViewController.className) as FullScreenViewController
        viewController.asset = assets[index]
        return viewController
    }
    
    private func configureCurrentViewController() {
        self.setViewControllers([self.viewControllerAtIndex(currentIndex)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
}
