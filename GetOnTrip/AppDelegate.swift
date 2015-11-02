//
//  AppDelegate.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/27.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

// $(TARGET_NAME)  项目名

import UIKit
import SSKeychain
import Alamofire

/// 全局变量记录用户账号  $(inherited)
var sharedUserAccount = UserAccount.loadAccount()
/// 记录uuid
var appUUID: String?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        ///  bug调试代码仅一行
        Bugtags.startWithAppKey("ec789dd0e94cd047205c87a0c9f05ac9", invocationEvent: BTGInvocationEventBubble)
        
        ///  获取uuid
        gainUserUUID()
        ///  写入cookie
        writeCookie()
        
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
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = SlideMenuViewController()
        window?.makeKeyAndVisible()
        
        //默认隐藏导航（navigationConroller在SlideMenuViewController中定义）
        UINavigationBar.appearance().hidden = true
        
        //cache
        let urlCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(urlCache)
        
        // 打开数据库
        // SQLiteManager.sharedSQLiteManager.openDB("status.db")
        
        // 注册第三方登陆分享应用相关信息
        registerAppInfo()
        
        return true
    }
    
    ///  将设备id写入cookie
    private func writeCookie() {
        
        var cookieProperties = [String: AnyObject]()
        cookieProperties[NSHTTPCookieName] = "device_id"
        cookieProperties[NSHTTPCookieValue] = appUUID!
        cookieProperties[NSHTTPCookieDomain] = "123.57.46.229"
        cookieProperties[NSHTTPCookieOriginURL] = "123.57.46.229"
        cookieProperties[NSHTTPCookiePath] = "/"
        cookieProperties[NSHTTPCookieVersion] = "0"
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(NSHTTPCookie(properties: cookieProperties)!)
        
        var cookieProperties1 = [String: AnyObject]()
        cookieProperties1[NSHTTPCookieName] = "current_user"
        cookieProperties1[NSHTTPCookieValue] = "z5K%2bXZURRu4%3d"
        cookieProperties1[NSHTTPCookieDomain] = "123.57.46.229"
        cookieProperties1[NSHTTPCookieOriginURL] = "123.57.46.229"
        cookieProperties1[NSHTTPCookiePath] = "/"
        cookieProperties1[NSHTTPCookieVersion] = "0"
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(NSHTTPCookie(properties: cookieProperties1)!)
    }
    
    // MARK: - 获取用户uuid
    private func gainUserUUID() {
        // 获取uuid
        var uuid = SSKeychain.passwordForService(NSBundle.mainBundle().bundleIdentifier, account: "uuid")
        if (uuid == nil) {
            uuid = NSUUID().UUIDString
            SSKeychain.setPassword(uuid, forService: NSBundle.mainBundle().bundleIdentifier, account: "uuid")
        }
        appUUID = uuid
    }

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
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权 2543743086 0ea741a8c5d9b3ffaeadf8d3a0659fb9
                    appInfo.SSDKSetupSinaWeiboByAppKey("1054799569",
                        appSecret : "ae886763688eeb8a732e26c30f91318d",
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




    // MARK: - 设置是否是第一次进入最新版本
//    private func defaultViewController() -> UIViewController {
//
//        return isNewUpdate() ? GuideViewController() : SlideMenuViewController()
//    }

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
    }


}

