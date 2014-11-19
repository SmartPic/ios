//
//  AppDelegate.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/05.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let settings = UIUserNotificationSettings(
            forTypes: UIUserNotificationType.Badge
                | UIUserNotificationType.Sound
                | UIUserNotificationType.Alert,
            categories: nil)
        application.registerUserNotificationSettings(settings);
        
        // Google Analytics
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Error
        GAI.sharedInstance().trackerWithTrackingId("UA-55951991-1")
        
        // UI
        UINavigationBar.appearance().barTintColor = UIColor.colorWithRGBHex(0x29b9ac)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        let allowedType = notificationSettings.types
        switch allowedType {
        case UIUserNotificationType.None:
            println("何も認証されていない")
        default:
            println("認証された")
            var notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 10)
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.alertBody = "message"
            notification.alertAction = "OK"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        }
    }
}

