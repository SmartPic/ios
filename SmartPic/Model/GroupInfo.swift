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
        self.location = self.placeFromAsset(assets.first)
    }
    
    func dateStrFromDate() -> String {
        if date == nil {
            return ""
        }
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        return dateFormatter.stringFromDate(self.date!)
    }
    
    func dateDictFromDate() -> Dictionary<String,String> {
        var dateDict = [
            "year": "",
            "date": "",
            "day": ""
        ]
        
        if date == nil {
            return dateDict
        }
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd/E"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let dateStr: String = dateFormatter.stringFromDate(self.date!)
        let dateArr = dateStr.componentsSeparatedByString("/")
        dateDict["year"] = dateArr[0]
        dateDict["date"] = dateArr[1] + "/" + dateArr[2]
        dateDict["day"] = dateArr[3]
        
        return dateDict
    }
    
    func placeFromAsset(asset: PHAsset?) -> CLLocation? {
        if asset == nil {
            return nil
        }
        
        let existAsset = asset!
        return existAsset.location as CLLocation?
    }
    
    // TODO: ここのcompletionHandler, errorの変数は必要か？
    // errorの場合に "" (空) を返すのならerrorの場合はaddress = ""とするルールでOKか。
    func loadAddressStr(completionHandler: ((address: String?, error: NSError?)->Void)) {
        // 読み込み済の場合
        if (self.placeStr != nil) {
            completionHandler(address: self.placeStr, error: nil)
            return
        }
        
        if location == nil {
            completionHandler(address: "", error: nil)
            return
        }
        
        let geoCorder = CLGeocoder()
        geoCorder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                completionHandler(address: nil, error: error)
                return
            }
            
            var places = placemarks as NSArray!
            if (places.count > 0) {
                var place: CLPlacemark = places[0] as CLPlacemark
                
                let state = place.addressDictionary["State"] as? NSString
                let city = place.addressDictionary["City"] as? NSString
                
                if (state != nil) && (city != nil) {
                    let languages = NSLocale.preferredLanguages() as [String]
                    let currentLanguage = languages.first
                    
                    if currentLanguage == "ja" {
                        // 日本語の場合はそのまま連結
                        self.placeStr = state! + city!
                    }
                    else {
                        // その他の場合は
                        self.placeStr = state! + " " + city!
                    }
                    
                }
                else {
                    self.placeStr = ""
                }
                completionHandler(address: self.placeStr, error: nil)
            }
            else {
                completionHandler(address: "", error: nil)
            }
        })
    }
}
