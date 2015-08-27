//
//  AppDelegate.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/27.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SSKeychain

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //status bar
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        
        //back button
        let backButtonImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        
        window?.rootViewController = defaultViewController()

        return true
    }

    
    // MARK: 设置是否是第一次进入最新版本
    private func defaultViewController() -> UIViewController {
        
        return isNewUpdate() ? GuideViewController() : SlideMenuViewController()
    }
    
    /// 是否新版本
    private func isNewUpdate() -> Bool {
        
        // 1. 获取应用程序`当前版本`
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! NSString
        let version = currentVersion.doubleValue
        
        // 2. 获取应用程序`之前的版本`，从用户偏好中读取
        let versionKey = "versionKey"
        let sandBoxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(versionKey)
        
        // 3. 将`当前版本`写入用户偏好
        NSUserDefaults.standardUserDefaults().setDouble(version, forKey: versionKey)
        
        return version > sandBoxVersion
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


}

