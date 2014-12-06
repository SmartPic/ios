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

class ReviewManager: NSObject {
   
    private override init() {
        super.init()
        
        // initialize
    }
    
    class func getInstance() -> ReviewManager {
        return reviewManager
    }
    
    private var deleteCount: Int = 0
    
    /////////////////////////////////////////////////
    
    private func saveDeleteCount() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(deleteCount, forKey: kReviewDeleteCount)
        defaults.synchronize()
    }
    
    func addDeleteCount(count: Int) {
        deleteCount += count
        
        println("current count is \(deleteCount)")
        
        saveDeleteCount()
    }
    
    func shouldShowReviewAlert() -> Bool {
        if deleteCount >= 10 {
            return true
        }
        
        return false
    }
    
}
