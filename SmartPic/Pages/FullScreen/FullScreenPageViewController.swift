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
    
    var currentIndex: Int = -1
    var assets: [PHAsset] = [] {
        didSet {
            if (currentIndex == -1) { return }
            self.configureCurrentViewController()
        }
    }
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UIPageViewController
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index: Int = self.indexOfViewController(viewController as FullScreenViewController) as Int
        if (index == NSNotFound ||
            index == 0) {
            return nil
        }
        
        return self.viewControllerAtIndex(index-1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index: Int = self.indexOfViewController(viewController as FullScreenViewController) as Int
        if (index == NSNotFound ||
            index == assets.count-1) {
            return nil
        }
        
        return self.viewControllerAtIndex(index+1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        let viewController: FullScreenViewController = pageViewController.viewControllers.last as FullScreenViewController
        currentIndex = self.indexOfViewController(viewController)
    }
    
    // MARK: Private methods
    
    private func indexOfViewController(viewController: FullScreenViewController) -> Int {
        for var i = 0; i < assets.count; i++ {
            if (assets[i].localIdentifier == viewController.asset.localIdentifier) {
                return i
            }
        }
        return NSNotFound
    }
    
    private func viewControllerAtIndex(index: Int) -> FullScreenViewController {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(FullScreenViewController.className) as FullScreenViewController
        viewController.asset = assets[index]
        return viewController
    }
    
    private func configureCurrentViewController() {
        self.setViewControllers([self.viewControllerAtIndex(currentIndex)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
}
