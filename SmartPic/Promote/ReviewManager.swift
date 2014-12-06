//
//  ReviewManager.swift
//  SmartPic
//
//  Created by himara2 on 2014/12/07.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

private let reviewManager = ReviewManager()

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
    
    func addDeleteEvent(num: Int) -> Bool {
        return true
    }
}
