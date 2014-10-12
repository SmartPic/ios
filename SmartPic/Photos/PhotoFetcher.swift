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
        
        self.assets = []
        self.fullAssets = []
        
        var prevDate: NSDate?
        var innerAssets: [PHAsset] = []
        
        var assets: PHFetchResult = PHAsset.fetchAssetsWithOptions(options)
        assets.enumerateObjectsUsingBlock { (obj: AnyObject!, idx: Int, stop) -> Void in
            var asset: PHAsset = obj as PHAsset
            self.fullAssets.append(asset)
            
            if prevDate != nil {
                var date: NSDate = asset.creationDate
                var interval: NSTimeInterval = date.timeIntervalSinceDate(prevDate!)
                if (interval > 2000) {
                    self.assets.append(innerAssets)
                    
                    innerAssets = []
                    innerAssets.append(asset)
                }
                else {
                    innerAssets.append(asset)
                }
            }
            else {
                innerAssets.append(asset)
            }
            
            prevDate = asset.creationDate
        }
        
        //println("photos = \(self.assets)")
        
        imageManager.startCachingImagesForAssets(fullAssets,
            targetSize: CGSizeMake(120, 120)
            , contentMode: .AspectFill,
            options: nil)
        
        return self.assets
    }
    
    func requestImageForAsset(asset: PHAsset, size: CGSize, resultHandler: ((image: UIImage!, info: [NSObject:AnyObject]!)  -> Void )) {
        self.imageManager.requestImageForAsset(asset,
            targetSize: size,
            contentMode: .AspectFill,
            options: nil,
            resultHandler:resultHandler)
    }
    
    func deleteImageAssets(assets: [PHAsset]) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            PHAssetChangeRequest.deleteAssets(assets)
        }, completionHandler: { (success, error) -> Void in
            println("success[\(success)]")
            println("error[\(error)]")
        })
    }
}

