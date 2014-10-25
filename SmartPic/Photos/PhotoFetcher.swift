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
    
    private func fetchCloudAssets() -> [PHAsset] {
        let collections = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .AlbumCloudShared, options: nil)
        var cloudAssets = [PHAsset]()
        collections.enumerateObjectsUsingBlock { (collection, idx, stop) -> Void in
            var assets = PHAsset.fetchAssetsInAssetCollection(collection as PHAssetCollection, options: nil)
            assets.enumerateObjectsUsingBlock({ (obj, idx, stop) -> Void in
                cloudAssets.append(obj as PHAsset)
            })
        }
        
        return cloudAssets
    }
    
    private func groupingPhotos(isExceptDeleted: Bool, isExceptICloud: Bool) -> [GroupInfo] {
        let cloudAssets = fetchCloudAssets()
        
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
            
            var isSkip = false
            // iCloudの写真を無視する
            if (isExceptICloud) {
                if contains(cloudAssets, asset) {
                    isSkip = true
                }
            }
            
            if (!isSkip) {
                if prevDate != nil {
                    var date: NSDate = asset.creationDate
                    var interval: NSTimeInterval = prevDate!.timeIntervalSinceDate(date)
                    
                    // 10秒以内に撮影された写真は同じグループだと考える
                    // それ以上離れた場合は別グループを作成する
                    if (interval > 10) {
                        if (!isExceptDeleted || self.shouldAppendAssets(innerAssets)) {
                            var group = GroupInfo(assets: innerAssets)
                            self.groups.append(group)
                        }
                        
                        innerAssets = []
                    }
                }
                
                innerAssets.append(asset)
                prevDate = asset.creationDate
            }
        }
        
        if (!innerAssets.isEmpty
            && (!isExceptDeleted || self.shouldAppendAssets(innerAssets))) {
            var group = GroupInfo(assets: innerAssets)
            self.groups.append(group)
        }
        
        return self.groups
    }
    
    private func groupingPhotosWithMoments(isExceptDeleted: Bool, isExceptICloud: Bool) -> [GroupInfo] {
        let cloudAssets = fetchCloudAssets()
        
        var momentOption = PHFetchOptions()
        momentOption.sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: false)
        ]
        
        var options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        self.groups = []
        
        var prevDate: NSDate?
        var innerAssets = [PHAsset]()
        
        let moments = PHAssetCollection.fetchMomentsWithOptions(momentOption)
        moments.enumerateObjectsUsingBlock { (moment, idx, stop) -> Void in
            
            let fetchResult = PHAsset.fetchAssetsInAssetCollection(moment as PHAssetCollection, options: options)
            
            fetchResult.enumerateObjectsUsingBlock({ (asset, idx, stop) -> Void in
                var isSkip = false
                if (isExceptICloud) {
                    if contains(cloudAssets, asset as PHAsset) {
                        isSkip = true
                    }
                }
                
                if !isSkip {
                    if prevDate != nil {
                        var date: NSDate = asset.creationDate
                        var interval: NSTimeInterval = prevDate!.timeIntervalSinceDate(date)
                        
                        // 10秒以内に撮影された写真は同じグループだと考える
                        // それ以上離れた場合は別グループを作成する
                        if (interval > 10) {
                            if (!isExceptDeleted || self.shouldAppendAssets(innerAssets)) {
                                var group = GroupInfo(assets: innerAssets)
                                self.groups.append(group)
                            }
                            
                            innerAssets = []
                        }
                    }
                    
                    innerAssets.append(asset as PHAsset)
                    prevDate = asset.creationDate
                }
                
            })
        }
        
        if (!innerAssets.isEmpty) {
            var group = GroupInfo(assets: innerAssets)
            self.groups.append(group)
        }
        
        return self.groups
    }
    
    func allPhotoGroupingByTime() -> [GroupInfo] {
        return groupingPhotos(false, isExceptICloud: false)
    }
    
    func targetPhotoGroupingByTime() -> [GroupInfo] {
        return groupingPhotos(true, isExceptICloud: false)
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

