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
   
    func registerAll () {
        self.registerDayOneNotification()
        self.registerDaySevenNotification()
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
            message: "message dayo-",
            buttonStr: "OK"
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
}
