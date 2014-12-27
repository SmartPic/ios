//
//  AnalyticsManager.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/11/24.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

enum AnalyticsDimension: UInt {
    case FirstDate = 1
    case DayFromFirstDay
    case DeletedFirstSession
    case GroupCount
    case PictureCountPerGroup
    case AllowedPushNotification
}

class AnalyticsManager: NSObject {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    let tracker = GAI.sharedInstance().defaultTracker;
    
    override init() {
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    }
    
    // 日付系のディメンションを設定
    func configureDateDimensions () {
        let firstDateStr: String? = defaults.objectForKey("FirstDate") as String?
        let todayDateFormatted: String = dateFormatter.stringFromDate(NSDate())
        
        if (firstDateStr == nil) {
            defaults.setObject(todayDateFormatted, forKey: "FirstDate")
            defaults.setBool(true, forKey: "FirstSession")
            
            tracker.set(GAIFields.customDimensionForIndex(AnalyticsDimension.FirstDate.rawValue), value: todayDateFormatted)
            tracker.set(GAIFields.customDimensionForIndex(AnalyticsDimension.DayFromFirstDay.rawValue), value: "0")
            
        } else {
            defaults.setBool(false, forKey: "FirstSession")
            
            let firstDate: NSDate = dateFormatter.dateFromString(firstDateStr!)!
            let now: NSDate = NSDate()
            let diffSec: Double = now.timeIntervalSinceDate(firstDate)
            let secondsOfADay: Double = 60 * 60 * 24
            let dayFromFirstDay: Int = Int(floor(diffSec/secondsOfADay))
            tracker.set(GAIFields.customDimensionForIndex(AnalyticsDimension.DayFromFirstDay.rawValue), value: "\(dayFromFirstDay)")
        }
        defaults.synchronize()
    }
    
    // 最初のセッションで削除した状態をセット
    func configureDeletedFirstSessionDimension () {
        tracker.set(GAIFields.customDimensionForIndex(AnalyticsDimension.DeletedFirstSession.rawValue), value: "Yes")
    }
    
    // グループ数、グループごとの写真数をセット
    func configureCountsDimension (groupInfoList: [GroupInfo]) {
        tracker.set(GAIFields.customDimensionForIndex(AnalyticsDimension.GroupCount.rawValue), value: "\(groupInfoList.count)")
        var photoCount = 0
        for groupInfo: GroupInfo in groupInfoList {
            photoCount += groupInfo.assets.count
        }
        let pictureCountPerGroup = ( Float(photoCount) / Float(groupInfoList.count) ).format("%.1f")
        tracker.set(GAIFields.customDimensionForIndex(AnalyticsDimension.PictureCountPerGroup.rawValue), value: pictureCountPerGroup)
    }
    
    // プッシュ通知許可状態をセット
    // allowed: "Yes" or "No"
    func configureNotificationDemension (allowed: String) {
        tracker.set(GAIFields.customDimensionForIndex(AnalyticsDimension.AllowedPushNotification.rawValue), value: allowed)
    }
}