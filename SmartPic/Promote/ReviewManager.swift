//
//  ReviewManager.swift
//  SmartPic
//
//  Created by himara2 on 2014/12/07.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

private let reviewManager = ReviewManager()

private let kReviewDeleteCount = "REVIEW_DELETE_COUNT"
private let kReviewDone = "REVIEW_DONE"

class ReviewManager: NSObject {
   
    private override init() {
        super.init()
        loadData()
    }
    
    class func getInstance() -> ReviewManager {
        return reviewManager
    }
    
    private var deleteCount: Int = 0
    private var isReviewDone = false
    
    /////////////////////////////////////////////////
    
    private func loadData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        deleteCount = defaults.integerForKey(kReviewDeleteCount)
        isReviewDone = defaults.boolForKey(kReviewDone)
    }
    
    private func saveDeleteCount() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(deleteCount, forKey: kReviewDeleteCount)
        defaults.synchronize()
    }
    
    // アプリのversionがあがったらレビュー状況をリセットする
    func resetReviewDone() {
        deleteCount = 0
        isReviewDone = false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(deleteCount, forKey: kReviewDeleteCount)
        defaults.setBool(isReviewDone, forKey: kReviewDone)
        defaults.synchronize()
    }
    
    // レビューしたら、そのversionではもう表示しない
    func checkReviewDone() {
        isReviewDone = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(isReviewDone, forKey: kReviewDone)
        defaults.synchronize()
    }
    
    func resetDeleteCount() {
        deleteCount = 0
        
        saveDeleteCount()
    }
    
    func addDeleteCount(count: Int) {
        deleteCount += count
        
        println("current count is \(deleteCount)")
        
        saveDeleteCount()
    }
    
    func shouldShowReviewAlert() -> Bool {
        // す
        if isReviewDone {
            return false
        }
        
        if deleteCount >= 10 {
            return true
        }
        
        return false
    }
    
}
