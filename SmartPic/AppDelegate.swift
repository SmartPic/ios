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
            forTypes: .Badge | .Sound | .Alert,
            categories: nil)
        application.registerUserNotificationSettings(settings);
        
        // Google Analytics
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Error
        GAI.sharedInstance().trackerWithTrackingId("UA-55951991-1")
        AnalyticsManager().configureDateDimensions()
        
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
            AnalyticsManager().configureNotificationDemension("No")
        default:
            AnalyticsManager().configureNotificationDemension("Yes")
        }
    }
}

