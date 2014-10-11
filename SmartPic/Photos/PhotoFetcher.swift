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
}

//
//UICollectionViewCell __weak *weakCell = cell;
//[self.imageManager requestImageForAsset:asset
//    targetSize:CGSizeMake(80, 80)
//    contentMode:PHImageContentModeAspectFill
//    options:nil
//    resultHandler:^(UIImage *result, NSDictionary *info) {
//    UIImageView *imageView = (UIImageView *)[weakCell viewWithTag:10];
//    imageView.image = result;
//    }];



/*
@interface ViewController ()

@property (nonatomic) NSMutableArray *assets;
@property (nonatomic) NSMutableArray *fullAssets;
@property (nonatomic) NSMutableArray *collectionLists;
@property (nonatomic) PHCachingImageManager *imageManager;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


__block NSDate *prevDate = nil;
__block NSMutableArray *innerAssets = @[].mutableCopy;

_fullAssets = @[].mutableCopy;
_assets = @[].mutableCopy;
PHFetchResult *assets = [PHAsset fetchAssetsWithOptions:options];
NSLog(@"assets.count = %ld", assets.count);
[assets enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL *stop) {
NSLog(@"作成日: %@", obj.creationDate);
[_fullAssets addObject:obj];

if (prevDate != nil) {
NSDate *date = obj.creationDate;
NSTimeInterval interval = [date timeIntervalSinceDate:prevDate];
NSLog(@"interval:[%f]", interval);

if (interval > 2000) {
NSLog(@"----- ここで仕切る -----");
[self.assets addObject:innerAssets];
innerAssets = @[].mutableCopy;
[innerAssets addObject:obj];
}
else {
[innerAssets addObject:obj];
}
}
else {
[innerAssets addObject:obj];
}
prevDate = obj.creationDate;
}];
if (innerAssets.count > 0) {
[self.assets addObject:innerAssets];
}

NSLog(@"_assets is %@", _assets);

[_imageManager startCachingImagesForAssets:_fullAssets
targetSize:CGSizeMake(80, 80)
contentMode:PHImageContentModeAspectFill
options:nil];

[self.collectionView reloadData];
}
*/