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
        
        if launchOptions != nil {
            let notification: UILocalNotification = launchOptions![UIApplicationLaunchOptionsLocalNotificationKey] as UILocalNotification
            handleByNotification(notification)
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if (application.applicationState == UIApplicationState.Inactive) {
            handleByNotification(notification)
        }
    }
    
    // UILocalNotification によって起動後の処理
    private func handleByNotification(notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            if let pushId: Int = userInfo["pushId"] as? Int {
                // 7日目プッシュでは StatusViewController を開く
                if (pushId == LocalPushId.DaySeven.rawValue) {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let statusNavigationViewController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("StatusNavigationController") as UINavigationController
                    self.window?.makeKeyAndVisible()
                    if let navigationController: UINavigationController = self.window?.rootViewController as? UINavigationController {
                        if (!navigationController.visibleViewController.isKindOfClass(StatusViewController)) {
                            navigationController.presentViewController(statusNavigationViewController, animated: true, completion: nil)
                        }
                    }
                }
                
                // Analytics のイベント送信
                let tracker = GAI.sharedInstance().defaultTracker;
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("launch by push", action: "localpush", label: "PUSHID-\(pushId)", value: 1).build())
            }
        }
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

