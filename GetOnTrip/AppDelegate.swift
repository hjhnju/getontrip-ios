//
//  AppDelegate.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/27.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

// $(TARGET_NAME)  项目名

import UIKit
import Alamofire
import CoreData
import YTKKeyValueStore
import SDWebImage
import AVFoundation

/// 全局变量记录用户账号  $(inherited)
var globalUser:UserAccount?
/// 全局缓存
var globalKvStore: YTKKeyValueStore?
/// 当前城市id
var currentCityId: String = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        NSThread.sleepForTimeInterval(2)
        
        //加载缓存(最早，否则config无法获取
        globalKvStore = YTKKeyValueStore(DBWithName: "getontrip")
        globalKvStore?.createTableWithName("ApiCache")
        
        //加载用户信息
        UserLogin.sharedInstance.loadAccount()
        
        //预先加载首页数据
//        let lastRequest = RecommendRequest()
//        lastRequest.fetchFirstPageModels {(data, status) -> Void in }
        
        // 初始化navbar
        initNavigationBar()
        
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        
        //cache
        let urlCache = NSURLCache(memoryCapacity: 40 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "httpcache")
        NSURLCache.setSharedURLCache(urlCache)
        SDImageCache.sharedImageCache().maxCacheSize  = 50 * 1024 * 1024
        SDImageCache.sharedImageCache().maxMemoryCost = 50 * 1024 * 1024
        SDImageCache.sharedImageCache().maxCacheAge   = 60 * 60 * 24 * 7

        // 注册登录分享应用相关信息
        LoginShare.shareLoginShare.registerLoginAndShareSetting()
        /// 注册统计相关
        Statistics.shareStatistics.registerStatisticsSetting()
        /// 注册测试设备
        Test().statisticsEquipmentRegister()
        /// 设置后台播放
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
//            try audioSession.setActive(true)
//        } catch {
//            print("不能后台播放")
//        }
        
        return true
    }
    
    private func initNavigationBar() {
        //status bar
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        
        let backButtonImage = UIImage(named: "icon_back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.yellowColor()
        UINavigationBar.appearance().barStyle = UIBarStyle.Default //白色半透明模糊
        UINavigationBar.appearance().clipsToBounds = false //包含状态栏
        UINavigationBar.appearance().shadowImage = UIImage() //1px line
        UINavigationBar.appearance().translucent = true //为false默认0点会下移
        UINavigationBar.appearance().barTintColor = UIColor.orangeColor()
        let bgImage = UIKitTools.imageWithColor(SceneColor.frontBlack)
        UINavigationBar.appearance().setBackgroundImage(bgImage, forBarMetrics: UIBarMetrics.Default)
        //默认隐藏导航（navigationConroller在SlideMenuViewController中定义）
        UINavigationBar.appearance().hidden = true
    }

    // MARK: - 设置是否是第一次进入最新版本
    private func defaultViewController() -> UIViewController {
//        return GuideViewController()
        return isNewUpdate() ? GuideViewController() : SlideMenuViewController()
//        return TempViewController()
    }

    // 是否新版本
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
        application.beginBackgroundTaskWithExpirationHandler(nil)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//        applicationDidReceiveMemoryWarning
    }
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        SDImageCache.sharedImageCache().clearMemory()
        SDWebImageManager.sharedManager().cancelAll()
    }

    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.

    }

}