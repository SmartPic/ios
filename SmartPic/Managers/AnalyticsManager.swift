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
    case AllowedPushNotificaion
}

class AnalyticsManager: NSObject {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    let tracker = GAI.sharedInstance().defaultTracker;
    
    override init() {
        dateFormatter.dateFormat = "yyyy/MM/dd"
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
    
    func configureDeletedFirstSessionDimension () {
        // 最初のセッションでなければ無視
        if (defaults.boolForKey("FirstSession") == false) { return }
        
        tracker.set(GAIFields.customDimensionForIndex(AnalyticsDimension.DeletedFirstSession.rawValue), value: "Yes")
    }
}