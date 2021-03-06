//
//  UserLogin.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/16.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

///  登录类型 1:qq,2:weixin,3:weibo
struct LoginType {
    /// 1
    static let QQ     = 1
    /// 2
    static let Weixin = 2
    /// 3
    static let Weibo  = 3
}

class UserLogin: NSObject {
    
    static var sharedInstance: UserLogin = UserLogin()
    
    /// 授权凭证， 为nil则表示尚未授权
    var credential: SSDKCredential = SSDKCredential()
    
    var loginRequest: UserLoginRequest = UserLoginRequest()
    
    /// 获取用户信息请求
    var infoRequest: UserInfoRequest = UserInfoRequest()
    
    /// 登录类型 1:qq,2:weixin,3:weibo
    var type: Int = LoginType.QQ
    
    /// 回调用于做完之后不影响之前的操作
    typealias LoginFinishedHandler = (result: Bool, error: NSError?) -> ()
    
    ///  用户登录
    ///  - parameter loginType: 登录平台类型
    ///  - parameter openId:    openId
    func login(loginType: Int, user: SSDKUser, handler: (Void -> Void)? = nil) {
        //当前无用户，先使用第三方用户信息
        globalUser = UserAccount(user: user, type: loginType)
        
        //向服务端请求登录，并合并用户信息（以服务端字段为准，无则补充第三方字段）
        loginRequest.openId = user.uid
        loginRequest.type   = loginType
        loginRequest.login() { (result, status) -> Void in
            if status == RetCode.SUCCESS {
                self.loadAccount({ (result, status) -> Void in
                    handler?()
                })
            } else if status == RetCode.NEED_ADDINFO {
                self.addAccountInfo()
            } else {
                //登录失败退出
                self.exit()
            }
        }
    }
    
    func login2() {
        
    }
    
    // MARK: - 退出登陆
    func exit() {
        globalUser = nil
        loginRequest.signout()
        // TODO: - 退出登陆需调用此方法
        Statistics.shareStatistics.profilesSignOff()
        NSNotificationCenter.defaultCenter().postNotificationName(UserInfoChangeNotification, object: true)
        do {
            try NSFileManager.defaultManager().removeItemAtPath(UserAccount.accountPath)
        } catch {
            //do nothing for empty file
        }
    }
    
    /// 加载用户信息
    func loadAccount(handler: ((AnyObject?, Int) -> Void)? = nil) {
        /// 程序启动先调用登陆状态如果后台说未登陆就让它下线
        
        //先使用本地用户信息
        if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accountPath) as? UserAccount {
            globalUser = account
        }
        //同时请求更新服务端信息
        self.infoRequest.get() { [weak self] (userinfo, status) -> Void in
            if status == RetCode.SUCCESS {
                //更新服务端用户最新信息
                if let userinfo = userinfo {
                    globalUser?.nickname = userinfo.nick_name
                    globalUser?.gender   = Int(userinfo.sex) ?? 0
                    globalUser?.icon     = userinfo.image
                    globalUser?.city     = userinfo.city
                    globalUser?.bakimg   = userinfo.bakimg
                    
                    self?.statisticsLoginAction(userinfo.id)
                }
                self?.saveAccount()
                handler?(userinfo, status)
            } else if status == RetCode.SESSION_NOT_LOGIN {
                //确定的未登录状态
                self?.exit()
                handler?(nil, status)
            } else {
                //其他情况不做处理，保留本地用户信息
                handler?(nil, status)
            }
        }
    }
    
    /// 统计账号方法
    private func statisticsLoginAction(id: String) {
        var loginType: String = ""
        
        if type == 1 {
            loginType = "QQ"
        } else if type == 2 {
            loginType = "WeiXin"
        } else if type == 3 {
            loginType = "Weibo"
        }
        
        Statistics.shareStatistics.profilesSignInWithPuid(id, loginType: loginType)
    }
    
    /**
    向服务端添加第三方用户信息
    */
    private func addAccountInfo() {
        if let user = globalUser {
            self.infoRequest.add(user) { (result, status) -> Void in
            }
        }
        self.saveAccount()
    }
    
    /// 上传用户个人信息
    func uploadUserInfo(imageData: [String : NSData?]?, sex: Int?, nick_name: String?, handler:(result: AnyObject?, status: Int?) -> Void) {
        
        let str = "/api/\(AppIni.ApiVersion)/user/editinfo"
        var post      = [String: String]()
        if sex       != nil { post["sex"]   = String(sex ?? 2) }
        if nick_name != nil { post["nick_name"] = nick_name ?? "" }
        
        let timestamp = String(format: "%.0f", NSDate().timeIntervalSince1970)
        post["token"] = "\(AppIni.SecretKey)\(timestamp)".sha256 + timestamp
        
        HttpRequest.sharedHttpRequest.upload(str, data: imageData, parameters: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                handler(result: result.object, status: status)
                return
            }
            handler(result: nil, status: status)
        }
    }
    
    ///  将当前对象归档保存至沙盒 `Keyed` 键值归档/解档
    private func saveAccount() {
        if let user = globalUser {
            NSKeyedArchiver.archiveRootObject(user, toFile: UserAccount.accountPath)
            NSNotificationCenter.defaultCenter().postNotificationName(UserInfoChangeNotification, object: true)
        }
    }
    
    var loginTypes = [LoginType.Weixin: SSDKPlatformType.TypeWechat, LoginType.QQ: SSDKPlatformType.TypeQQ, LoginType.Weibo:SSDKPlatformType.TypeSinaWeibo]
    
    private func getThirdType(loginType: Int) -> SSDKPlatformType {
        return loginTypes[loginType] ?? SSDKPlatformType.TypeWechat
    }
    
    //第三方登陆
    func thirdLogin(loginType: Int, finishHandler: LoginFinishedHandler?, handler: (Void -> Void)? = nil) {
        let ssdkType = getThirdType(loginType)
        //授权
        ShareSDK.authorize(ssdkType, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
            
            switch state{
            case SSDKResponseState.Success:
            // print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
                self.login(loginType, user: user, handler: { (_) -> Void in
                    finishHandler?(result: true, error: nil)
                })
            case SSDKResponseState.Fail:
                print("授权失败,错误描述:\(error)")
                finishHandler?(result: false, error: error)
            case SSDKResponseState.Cancel:
                print("操作取消")
            default:
                break
            }
            handler?()
        })
    }
}
