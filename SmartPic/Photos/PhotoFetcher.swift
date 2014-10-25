//
//  PhotoFetcher.swift
//  SmartPic
//
//  Created by himara2 on 2014/10/07.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class PhotoFetcher: NSObject {
    
    var groups = [GroupInfo]()
    var imageManager: PHCachingImageManager
    let deleteManager: DeleteManager?
    
    var isFinishPhotoLoading = false

    override init() {
        self.imageManager = PHCachingImageManager()
        self.deleteManager = DeleteManager.getInstance()
        super.init()
        
        loadStatus()
    }
    
    private func loadStatus() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let isRead = defaults.boolForKey("IS_FINISH_PHOTO_LOADING")
        self.isFinishPhotoLoading = isRead
    }
    
    func setFinishPhotoLoading() {
        self.isFinishPhotoLoading = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(isFinishPhotoLoading, forKey: "IS_FINISH_PHOTO_LOADING")
        defaults.synchronize()
    }
    
    func allPhotoGroupingByTime() -> [GroupInfo] {
        var options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        self.groups = []
        
        var prevDate: NSDate?
        var innerAssets = [PHAsset]()
        
        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        assets.enumerateObjectsUsingBlock { (obj: AnyObject!, idx: Int, stop) -> Void in
            var asset: PHAsset = obj as PHAsset
            
            if prevDate != nil {
                var date: NSDate = asset.creationDate
                var interval: NSTimeInterval = prevDate!.timeIntervalSinceDate(date)
                
                // 3秒（3000ミリ秒）以内に撮影された写真は同じグループだと考える
                // それ以上離れた場合は別グループを作成する
                if (interval > 3000) {
                    var group = GroupInfo(assets: innerAssets)
                    self.groups.append(group)
                    
                    innerAssets = []
                }
            }
            
            innerAssets.append(asset)
            prevDate = asset.creationDate
        }
        
        if (!innerAssets.isEmpty) {
            var group = GroupInfo(assets: innerAssets)
            self.groups.append(group)
        }
        
        return self.groups
    }
    
    func targetPhotoGroupingByTime() -> [GroupInfo] {
        var options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        self.groups = []
        
        var prevDate: NSDate?
        var innerAssets = [PHAsset]()
        
        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        assets.enumerateObjectsUsingBlock { (obj: AnyObject!, idx: Int, stop) -> Void in
            var asset: PHAsset = obj as PHAsset
            
            if prevDate != nil {
                var date: NSDate = asset.creationDate
                var interval: NSTimeInterval = prevDate!.timeIntervalSinceDate(date)
                
                // 10秒以内に撮影された写真は同じグループだと考える
                // それ以上離れた場合は別グループを作成する
                if (interval > 10) {
                    if (self.shouldAppendAssets(innerAssets)) {
                        var group = GroupInfo(assets: innerAssets)
                        self.groups.append(group)
                    }
                    
                    innerAssets = []
                }
            }
            
            innerAssets.append(asset)
            prevDate = asset.creationDate
        }
        
        if (!innerAssets.isEmpty) {
            var group = GroupInfo(assets: innerAssets)
            self.groups.append(group)
        }

        return self.groups
    }
    
    
    private func shouldAppendAssets(assets: [PHAsset]) -> Bool {
        // 1枚のものは無視する
        if (assets.count < 2) {
            return false
        }
        
        // すでに整理済みのグループは無視する
        if (deleteManager!.isArrangedGroup(assets)) {
            return false
        }
        return true
    }
    
    func requestImageForAsset(asset: PHAsset, size: CGSize, resultHandler: ((image: UIImage!, info: [NSObject:AnyObject]!)  -> Void )) {
        self.imageManager.requestImageForAsset(asset,
            targetSize: size,
            contentMode: .AspectFill,
            options: nil,
            resultHandler:resultHandler)
    }
    
    func deleteImageAssets(assets: [PHAsset], completionHandler:((success:Bool, error:NSError?) -> Void)) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            PHAssetChangeRequest.deleteAssets(assets)
        }, completionHandler:completionHandler)
    }
}

