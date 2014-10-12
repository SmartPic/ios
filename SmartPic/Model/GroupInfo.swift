//
//  GroupInfo.swift
//  SmartPic
//
//  Created by 平松　亮介 on 2014/10/13.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit
import Photos
import CoreLocation

class GroupInfo: NSObject {
    var assets = [PHAsset]()
    private var date: NSDate?
    private var location: CLLocation?
    private var placeStr: String?

    override init() {
        super.init()
    }
    
    init(assets: [PHAsset]) {
        super.init()
        self.assets = assets
        self.date = assets.first?.creationDate
        self.location = self.placeStrFromAsset(assets.first)
    }
    
    func placeStrFromAsset(asset: PHAsset?) -> CLLocation? {
        if asset == nil {
            return nil
        }
        
        let existAsset = asset!
        return existAsset.location as CLLocation?
    }
    
    func loadAddressStr() {
        let geoCorder = CLGeocoder()
        geoCorder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) -> Void in
            var places = placemarks as NSArray!
            if (places.count > 0) {
                println("placemarks is \(places.description)")
                self.placeStr = places.description
            }
        })
    }
}
