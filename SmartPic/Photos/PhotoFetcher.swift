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

    override init() {
        self.imageManager = PHCachingImageManager()
    }
    
    func photosTimeImmediately() -> [GroupInfo] {
        //println("photos stand-by")
        
        var options = PHFetchOptions()
        options.includeAllBurstAssets = false
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

