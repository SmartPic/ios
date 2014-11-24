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
//        self.registerDayOneNotification()
//        self.registerDaySevenNotification()
        registerTest()
    }
    
    func reset () {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        registerAll()
    }
    
    private func registerDayOneNotification () {
        registerWithParams(
            getFireDateWithInterval(1),
            message: "message dayo-",
            buttonStr: "OK"
        )
    }
    
    private func registerDaySevenNotification () {
        registerWithParams(
            getFireDateWithInterval(7),
            message: "Alpacaを1週間使ってどれくらい容量が空いたか確認してみよう！",
            buttonStr: "確認する"
        )
    }
    
    private func registerWithParams (fireDate: NSDate, message: String, buttonStr: String) {
        var notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.timeZone = NSTimeZone.localTimeZone()
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

    // TODO: 消す
    private func registerTest () {
        
        let allSizeNum = photoFetcher.calculateAllSize() * 5
        var allSizeStr: String
        if (allSizeNum > 1000) {
            allSizeStr =
        }
        var notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.alertBody = "あなたは \(allSizeStr)MB アルバムで使用しています。Alpaca でサクサク整理しよう！"
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}
