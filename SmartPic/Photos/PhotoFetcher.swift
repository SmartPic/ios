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
    
    var assets: [[PHAsset]] = []
    var fullAssets: [PHAsset] = []
    var imageManager: PHCachingImageManager

    override init() {
        self.imageManager = PHCachingImageManager()
    }
    
    func photosTimeImmediately() -> [[PHAsset]] {
        //println("photos stand-by")
        
        var options = PHFetchOptions()
        options.includeAllBurstAssets = false
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        self.assets = []
        self.fullAssets = []
        
        var prevDate: NSDate?
        var innerAssets: [PHAsset] = []
        
        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        assets.enumerateObjectsUsingBlock { (obj: AnyObject!, idx: Int, stop) -> Void in
            var asset: PHAsset = obj as PHAsset
            self.fullAssets.append(asset)
            
            if prevDate != nil {
                var date: NSDate = asset.creationDate
                var interval: NSTimeInterval = prevDate!.timeIntervalSinceDate(date)
                
                // 3秒（3000ミリ秒）以内に撮影された写真は同じグループだと考える
                // それ以上離れた場合は別グループを作成する
                if (interval > 3000) {
                    self.assets.append(innerAssets)
                    
                    innerAssets = []
                }
            }
            
            innerAssets.append(asset)
            prevDate = asset.creationDate
        }
        
        if (!innerAssets.isEmpty) {
            self.assets.append(innerAssets)
        }

        return self.assets
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

