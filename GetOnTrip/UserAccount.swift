//
//  UserAccount.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/5.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class UserAccount: NSObject, NSCoding {
    
    /// 授权凭证， 为nil则表示尚未授权
    var credential: SSDKCredential = SSDKCredential()
    
    /// 用户标识
    var uid: String = ""
    
    /// 昵称
    var nickname: String = ""
    
    /// 头像
    var icon: String = ""
    
    /// 性别
    var gender: Int = 0
    
    /// 城市
    var city: String = ""
    
    /// 原始数据
    var rawData: NSDictionary = NSDictionary()
    
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String = ""
    
    /// access_token的生命周期，单位是秒数(实际是数值！)
    var expires_in: NSTimeInterval = NSTimeInterval()
    
    /// 过期日期
    var expiresDate: NSDate = NSDate()
    
    /// 告诉后台用户登陆
    var informLoginRequest: UserLoghtRequest = UserLoghtRequest()

    /// 获取用户信息请求
    var userInfoGainRequest: UserInfoRequest = UserInfoRequest()
    
    /// 添加用户信息
    var userAddRequest: UserAddRequest = UserAddRequest()
    
    /// 退出登陆
    var userExitLoginRequest: UserExitLoghtRequest = UserExitLoghtRequest()
    
    /// 检查用户是否登陆
    var userLoginInsepctRequest: UserLoginInsepctRequest = UserLoginInsepctRequest()
    
    /// 登陆类型 1:qq,2:weixin,3:weibo
    var type: Int = 0
    init(user: SSDKUser?, type: Int) {
        
        credential = user?.credential ?? SSDKCredential()
        uid        = user?.uid ?? ""
        nickname   = user?.nickname ?? ""
        icon       = user?.icon ?? ""
        gender     = user?.gender.hashValue ?? 0
        rawData    = user?.rawData ?? NSDictionary()
        self.type  = type
        super.init()

        // MARK: - 用户一旦登陆成功即刻告诉后台设置用户登陆状态
        informLoginStatus(type, openId: user?.uid ?? "")
    }
    
    ///  设置用户登陆状态
    ///
    ///  - parameter loginType: 登陆平台类型
    ///  - parameter openId:    openId
    private func informLoginStatus(loginType: Int, openId: String) {
        informLoginRequest.openId = openId
        informLoginRequest.type = loginType
        informLoginRequest.fetchLoginModels { (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if (result != nil) {
                    ///  替换服务器用户的个人信息
                    self.userInfoGain(self.type)
                } else {
                    SVProgressHUD.showErrorWithStatus("登陆失败，请重新登陆")
                    return
                }
            } else {
                SVProgressHUD.showErrorWithStatus("登陆失败，请重新登陆")
                return
            }
        }
    }
    
    ///  获取用户信息
    ///
    ///  - parameter loginType: 登陆平台
    private func userInfoGain(loginType: Int) {
        userInfoGainRequest.type = loginType
        
        userInfoGainRequest.userInfoGainMeans({ (handler) -> Void in
            let user = handler as UserInfo
            if user.type == "1" {
                self.nickname = user.nick_name
                self.icon     = user.image
                self.city     = user.city
                self.gender   = Int(user.sex) ?? 0
                
            } else { // 此用户后台没有记录在册
                
                ///  添加用户
                self.userAddInfo()
            }
            self.saveAccount()
        })
    }
    
    // MARK: - 用户登陆后添加用户信息
    private func userAddInfo() {
        
        userAddRequest.type = type
        
        userAddRequest.param = self
        userAddRequest.userAddInfoMeans()
        
    }
    
     // MARK: - 上传用户个人信息
    func uploadUserInfo(imageData: NSData, sex: Int?, nick_name: String?, city: String?, handler:(result: AnyObject?, error: NSError?) -> Void) {
        
        let str = "/api/user/editinfo"
        
        var post         = [String: String]()
        post["type"]  = String(self.type)
        post["sex"]   = String(sex)
        post["nick_name"] = nick_name
        post["city"]  = city
    
        HttpRequest.sharedHttpRequest.upload(str, data: imageData, parameters: post) { (result, error) -> () in
            if error != nil {
                print("网络加载失败")
                handler(result: result, error: error)
                return
            }
            handler(result: nil, error: error)
            self.userInfoGain(self.type)
        }

    }
    
    ///  用户退出方法
    func userExitLoginAction() {
        
        userExitLoginRequest.fetchExitLoginModels()
    }
    
    /// MARK: - 保存和加载文件
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("/account.plist")
    
    // MARK: - 退出登陆
    func exitLogin() {
        sharedUserAccount = nil
        userExitLoginAction()
        NSNotificationCenter.defaultCenter().postNotificationName(UserInfoChangeNotification, object: true)

        do {
            try NSFileManager.defaultManager().removeItemAtPath(UserAccount.accountPath)
        } catch {
            print(error)
        }
    }
    
    ///  将当前对象归档保存至沙盒 `Keyed` 键值归档/解档
    func saveAccount() {
        sharedUserAccount = self
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
        NSNotificationCenter.defaultCenter().postNotificationName(UserInfoChangeNotification, object: true)
    }
    
    
    class func loadAccount() -> UserAccount? {
        
         /// 程序启动先调用登陆状态如果后台说未登陆就让它下线
        print("load account, path=\(UserAccount.accountPath), path=\(accountPath)")
        if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount {
            
            print("load account=\(account)")
            
            account.userLoginInsepctRequest.fetchInsepctUserLogin({ (handler) -> Void in
                if handler as? String == "" {
                    account.exitLogin()
                }
            })
            
            // 判断日期是否过期，根当前系统时间进行`比较`，低于当前系统时间，就认为过期
            // 过期日期`大于`当前日期，结果应该是降序
//            if account.credential!.expired!.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                return account
//            }
        }
        
        return nil
    }
    
    // MARK: - NSCoding 归档解档
    ///  解档，将保存在磁盘的二进制文件转换成 对象
    required init(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String ?? ""
        expiresDate  = aDecoder.decodeObjectForKey("expiresDate")  as? NSDate ?? NSDate()
        uid          = aDecoder.decodeObjectForKey("uid")          as? String ?? ""
        nickname     = aDecoder.decodeObjectForKey("nickname")     as? String ?? ""
        icon         = aDecoder.decodeObjectForKey("icon")         as? String ?? ""
        gender       = aDecoder.decodeObjectForKey("gender")       as? Int    ?? 0
        city         = aDecoder.decodeObjectForKey("city")         as? String ?? ""
        type         = aDecoder.decodeIntegerForKey("type")        as  Int
    }
    
    ///  归档，aCoder 编码器，将对象转换成二进制数据保存到磁盘
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(nickname, forKey: "nickname")
        aCoder.encodeObject(icon, forKey: "icon")
        aCoder.encodeObject(gender, forKey: "gender")
        aCoder.encodeObject(city, forKey: "city")
        aCoder.encodeInteger(type, forKey: "type")
    }
}
