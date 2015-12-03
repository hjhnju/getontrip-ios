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
        
        NSThread.sleepForTimeInterval(2)
        
        //加载缓存(最早，否则config无法获取
        globalKvStore = YTKKeyValueStore(DBWithName: "getontrip")
        globalKvStore?.createTableWithName("ApiCache")
        
        //加载用户信息
        UserLogin.sharedInstance.loadAccount()
        
        //预先加载首页数据
        let lastRequest = RecommendRequest()
        lastRequest.fetchFirstPageModels {(data, status) -> Void in }
        
        // 初始化navbar
        initNavigationBar()
        
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        //cache
        let urlCache = NSURLCache(memoryCapacity: 40 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "httpcache")
        NSURLCache.setSharedURLCache(urlCache)

        // 注册第三方登陆分享应用相关信息
        registerAppInfo()
        
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
        //return GuideViewController()
        return isNewUpdate() ? GuideViewController() : SlideMenuViewController()
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
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.

    }

}

// 第三方写在此方法中
extension AppDelegate {
    // MARK: - 注册第三方登陆分享应用相关信息
    private func registerAppInfo() {
        
        /**
        *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
        *  在将生成的AppKey传入到此方法中。
        *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
        *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
        *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
        */
        
        ShareSDK.registerApp("b054f1b715c0",
            
            activePlatforms: [SSDKPlatformType.TypeSinaWeibo.rawValue,
                SSDKPlatformType.TypeQQ.rawValue,
                SSDKPlatformType.SubTypeQZone.rawValue,
                SSDKPlatformType.TypeWechat.rawValue,
                SSDKPlatformType.TypeCopy.rawValue,
                SSDKPlatformType.SubTypeWechatTimeline.rawValue],
            onImport: {(platform : SSDKPlatformType) -> Void in
                
                switch platform {
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                case SSDKPlatformType.TypeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo.SSDKSetupSinaWeiboByAppKey("2543743086",
                        appSecret : "0ea741a8c5d9b3ffaeadf8d3a0659fb9",
                        redirectUri : "http://www.baidu.com",
                        authType : SSDKAuthTypeBoth)
                    break
                    
                    
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wx2af0c4fd046e238f", appSecret: "bbc1c1086c1c5ef7bad02489c4e18ea5")
                    break
                    
                    //41DA59A7
                case SSDKPlatformType.TypeQQ:
                    appInfo.SSDKSetupQQByAppId("1104828839", appKey: "vBDGLyCowfoWikog", authType: SSDKAuthTypeBoth)
                default:
                    break
                }
        })
    }
}