//
//  LocalPushManager.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/11/22.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

class LocalPushManager: NSObject {
    
    let secondsOfADay = 60 * 60 * 24
    private let photoFetcher = PhotoFetcher()
   
    func registerAll () {
        registerDayOneNotification()
        registerDaySevenNotification()
    }
    
    func reset () {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        registerAll()
    }
    
    private func registerDayOneNotification () {
        let allSizeNum = photoFetcher.calculateAllSize()
        var allSizeStr: String
        if (allSizeNum > 1000) {
            allSizeStr = (Float(allSizeNum) / 1000).format("%.1f") + "GB"
        } else {
            allSizeStr = String(allSizeNum) + "MB"
        }
        
        registerWithParams(
            getFireDateWithInterval(1),
            message: String(format: NSLocalizedString("The camera roll's size is approximately %@. Delete abundant photos!", comment:""), allSizeStr),
            buttonStr: NSLocalizedString("Open ALPACA", comment:"")
        )
    }
    
    private func registerDaySevenNotification () {
        registerWithParams(
            getFireDateWithInterval(7),
            message: NSLocalizedString("Loot at the result of using ALPACA for a week!", comment:""),
            buttonStr: NSLocalizedString("Open ALPACA", comment:"")
        )
    }
    
    private func registerWithParams (fireDate: NSDate, message: String, buttonStr: String) {
        var notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = message
        notification.alertAction = buttonStr
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    private func getFireDateWithInterval (day: Int) -> NSDate {
        let tagetDate: NSDate = NSDate(timeIntervalSinceNow: Double(day * secondsOfADay))
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd/HH/Z"
        let targetDateFormatted: String = formatter.stringFromDate(tagetDate)
        var dateArr: [String] = targetDateFormatted.componentsSeparatedByString("/") as [String]
        dateArr[3] = "21"
        let fireDateFormatted: String = "/".join(dateArr)
        let fireDate: NSDate = formatter.dateFromString(fireDateFormatted)!
        return fireDate
    }
}
