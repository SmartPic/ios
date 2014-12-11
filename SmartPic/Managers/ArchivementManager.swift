//
//  ArchivementManager.swift
//  SmartPic
//
//  Created by himara2 on 2014/12/08.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

private let archivementManager = ArchivementManager()

class ArchivementManager: NSObject {
   
    override private init() {
        super.init()
    }
    
    class func getInstance() -> ArchivementManager {
        return archivementManager
    }
    
    private let archivePoint = [6, 100, 300, 500, 700, 1000]   // この枚数の削除を達成したときにアクションを行う
    
    //////////////////////////////////////
    
    
    func pointScoreIfArchive() -> Int? {
        let deleteManager = DeleteManager.getInstance()
        let delCount = deleteManager.deleteAssetIds.count
        
        // 達成できた最大のポイントを返す
        var maxArchivePoint: Int? = nil
        for point in archivePoint {
            if delCount >= point {
                maxArchivePoint = point
            }
        }
        
        if maxArchivePoint != nil {
            
            if isArchivementActionDone(maxArchivePoint!) {
                return nil
            }
        }
        
        return maxArchivePoint
    }
    
    private func isArchivementActionDone(archivePoint: Int) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        let archiveKey = "ARCHIVEMENT_DONE_\(archivePoint)"

        return defaults.boolForKey(archiveKey)
    }
    
    func saveArchiveActionDone(archivePoint: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let archiveKey = "ARCHIVEMENT_DONE_\(archivePoint)"
        defaults.setBool(true, forKey: archiveKey)
        defaults.synchronize()
    }
}
