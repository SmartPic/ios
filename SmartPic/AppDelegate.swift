//
//  AppDelegate.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/05.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

private let kAppVersion = "APP_VERSION"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Google Analytics
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Error
        GAI.sharedInstance().trackerWithTrackingId("UA-55951991-1")
        
        // UI
        UINavigationBar.appearance().barTintColor = UIColor.colorWithRGBHex(0x29b9ac)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        if isUpdate() {
            // アップデート時に行う処理
            
            // レビューしたかどうかはリセット
            let reviewManager = ReviewManager.getInstance()
            reviewManager.resetReviewDone()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    private func isUpdate() -> Bool {
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let saveVersion = defaults.objectForKey(kAppVersion) as? String
        
        if saveVersion == nil {
            // 初めてのインストール
            defaults.setObject(currentVersion, forKey: kAppVersion)
            println("first install! current version:[\(currentVersion!)]")
            return true
        }
        else {
            // バージョンが違う
            if saveVersion != currentVersion {
                defaults.setObject(currentVersion, forKey: kAppVersion)
                println("save version:[\(saveVersion!)] <-> current version:[\(currentVersion!)]")
                return true
            }
            else {
                println("same version")
                return false
            }
        }
    }
}

