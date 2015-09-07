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

/// 全局变量记录用户账号
var sharedUserAccount = UserAccount.loadAccount()
/// 记录uuid
var appUUID: String?

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

        let urlCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(urlCache)
        
        
        // 注册第三方登陆分享应用相关信息
        registerAppInfo()
        
        // 获取用户uuid
        gainUserUUID()
    
        return true
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
        
        ShareSDK.registerApp("a28324e69186",
            
            activePlatforms: [SSDKPlatformType.TypeSinaWeibo.rawValue, // 新浪微博
                SSDKPlatformType.SubTypeWechatSession.rawValue,        // 微信好友
                SSDKPlatformType.SubTypeWechatTimeline.rawValue,       // 微信朋友圈
                SSDKPlatformType.SubTypeQZone.rawValue],               // qq空间
            onImport: {(platform : SSDKPlatformType) -> Void in
                
                switch platform{
                    // 调用微信接口
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    // 调用qq接口
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                    // 未调用新浪接口，文档说不调用并不影响授权及分享功能
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                    // TODO: 以下应用均未在相关应用进行过注册，模拟器无法检测，只能使用真机
                case SSDKPlatformType.TypeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo.SSDKSetupSinaWeiboByAppKey("568898243",
                        appSecret : "38a4f8204cc784f81f9f0daaf31e02e3",
                        redirectUri : "http://www.sharesdk.cn",
                        authType : SSDKAuthTypeBoth)
                    break
                    
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
//                    appInfo.SSDKSetupWeChatByAppId("wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
                    break
                    
                case SSDKPlatformType.TypeTencentWeibo:
                    //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
                    appInfo.SSDKSetupTencentWeiboByAppKey("801307650",
                        appSecret : "ae36f4ee3946e1cbb98d6965b0b2ff5c",
                        redirectUri : "http://www.sharesdk.cn")
                    break
                case SSDKPlatformType.TypeFacebook:
                    //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                    appInfo.SSDKSetupFacebookByAppKey("107704292745179",
                        appSecret : "38053202e1a5fe26c80c753071f0b573",
                        authType : SSDKAuthTypeBoth)
                    break
                default:
                    break
                    
                }
        })

    }


    // MARK: - 设置是否是第一次进入最新版本
    private func defaultViewController() -> UIViewController {
        
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
    }


}

