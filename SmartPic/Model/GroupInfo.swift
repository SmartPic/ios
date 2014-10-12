//
//  GroupInfo.swift
//  SmartPic
//
//  Created by 平松　亮介 on 2014/10/13.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos

class GroupInfo: NSObject {
    var assets = [PHAsset]()
    private var dateStr = ""
    private var placeStr: String?

    override init() {
        super.init()
    }
    
    init(assets: [PHAsset]) {
        super.init()
        self.assets = assets
        self.dateStr = self.dateStrFromAsset(assets.first)
        self.placeStr = self.placeStrFromAsset(assets.first)
    }

    func dateStrFromAsset(asset: PHAsset?) -> String {
        return "date"
    }
    
    func placeStrFromAsset(asset: PHAsset?) -> String {
        return "place"
    }
}
