//
//  DeleteManager.swift
//  SmartPic
//
//  Created by himara2 on 2014/10/22.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

private let deleteManager = DeleteManager()

class DeleteManager: NSObject {
   
    var deleteAssetIds = [String]()
    var deleteAssetFileSize:Float = 0
    
    override private init() {
        super.init()
        self.loadData()
    }
    
    class func getInstance() -> DeleteManager {
        return deleteManager
    }
    
    //////////////////////////////////////
    
    func loadData() {
        // 過去に削除したidリストをNSUserDefaultsから取得
        let defaults = NSUserDefaults.standardUserDefaults()
        let loadArray = defaults.arrayForKey("DELETE_ASSET_IDS")
        
        if loadArray != nil {
            self.deleteAssetIds = loadArray as [String]
        }
        
        let loadFloat = defaults.floatForKey("DELETE_ASSET_FILE_SIZE")
        self.deleteAssetFileSize = loadFloat as Float
    }
    
    // 削除したデータを保存
    func saveDeletedAssets(assets: [PHAsset]) {
        var ids = [String]()
        for asset in assets {
            let a = asset as PHAsset
            
            // 削除したファイルサイズの計算
            fetchPhotoSizeWithAsset(a)
            
            ids.append(a.localIdentifier)
        }
        
        self.deleteAssetIds += ids
        
        println("これまでに削除した写真の枚数: \(deleteAssetIds.count)")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self.deleteAssetIds, forKey: "DELETE_ASSET_IDS")
        defaults.synchronize()
    }
    
    func isArrangedGroup(assets: [PHAsset]) -> Bool {
        for asset in assets {
            if contains(self.deleteAssetIds, asset.localIdentifier) {
                return true
            }
        }
        return false
    }
    
    private func fetchPhotoSizeWithAsset(asset: PHAsset) {
        
        let imageManager = PHCachingImageManager()
        imageManager.requestImageDataForAsset(asset, options: nil) { (data, dataUTI, orientation, info) -> Void in

            var imageSize = Float(data.length)
            imageSize = imageSize/(1024*1024)   // MBに変換
            
            self.saveDeletedPhotoSize(imageSize)
        }
    }
    
    private func saveDeletedPhotoSize(size: Float) {        
        self.deleteAssetFileSize += size
        
        println("削除した画像のサイズ: \(size) => 累計削除ファイルサイズ: \(self.deleteAssetFileSize) MB")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self.deleteAssetFileSize, forKey: "DELETE_ASSET_FILE_SIZE")
        defaults.synchronize()
    }
}
