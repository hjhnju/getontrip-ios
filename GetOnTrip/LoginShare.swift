//
//  LoginShare.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/12.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

/// 登陆和分享
class LoginShare {
    
    static let shareLoginShare = LoginShare()
    
    /// 注册登陆和分享相关配置
    func registerLoginAndShareSetting() {
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
