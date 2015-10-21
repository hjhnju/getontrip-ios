//
//  UserAccount.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/5.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import Alamofire

class UserAccount: NSObject, NSCoding {
    
    /// 授权凭证， 为nil则表示尚未授权
    var credential: SSDKCredential?
    
    /// 用户标识
    var uid: String?
    
    /// 昵称
    var nickname: String?
    
    /// 头像
    var icon: String?
    
    /// 性别
    var gender: Int?
    
    /// 城市
    var city: String?
    
    /// 原始数据
    var rawData: NSDictionary?
    
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    /// access_token的生命周期，单位是秒数(实际是数值！)
    var expires_in: NSTimeInterval?
    
    /// 过期日期
    var expiresDate: NSDate?
    
    /// 告诉后台用户登陆
    var informLoginRequest: UserLoghtRequest?

    /// 获取用户信息请求
    var userInfoGainRequest: UserInfoRequest?
    
    /// 添加用户信息
    var userAddRequest: UserAddRequest?
    
    
    /// 登陆类型 1:qq,2:weixin,3:weibo
    var type: Int = 0
    init(user: SSDKUser?, type: Int) {
        
        credential = user!.credential
        uid        = user!.uid
        nickname   = user!.nickname
        icon       = user!.icon
        gender     = user!.gender.hashValue
        rawData    = user!.rawData
        self.type  = type
        super.init()

        // MARK: - 用户一旦登陆成功即刻告诉后台设置用户登陆状态
        informLoginStatus(type, openId: user!.uid)
        
        ///  替换服务器用户的个人信息
        userInfoGain(type)
    }
    
    ///  设置用户登陆状态
    ///
    ///  - parameter loginType: 登陆平台类型
    ///  - parameter openId:    openId
    private func informLoginStatus(loginType: Int, openId: String) {
        if informLoginRequest == nil {
            informLoginRequest = UserLoghtRequest()
            informLoginRequest?.openId = openId
            informLoginRequest?.type = loginType
        }
        informLoginRequest?.fetchLoginModels()
    }
    
    ///  获取用户信息
    ///
    ///  - parameter loginType: 登陆平台
    private func userInfoGain(loginType: Int) {
        if userInfoGainRequest == nil {
            userInfoGainRequest = UserInfoRequest()
            userInfoGainRequest?.type = loginType
        }
        userInfoGainRequest?.userInfoGainMeans({ (handler) -> Void in
            let user = handler as UserInfo
            if user.type == "1" {
                self.nickname = user.nick_name
                self.icon     = user.image
                self.city     = user.city
                self.gender   = Int(user.sex)
                
            } else { // 此用户后台没有记录在册
                
                ///  添加用户
                self.userAddInfo()
            }
            self.saveAccount()
        })
    }
    
    // MARK: - 用户登陆后添加用户信息
    private func userAddInfo() {
        
        if userAddRequest == nil {
            userAddRequest = UserAddRequest()
            userAddRequest?.type = type

            let params = "sex:\(gender!),nick_name:\(nickname!),image:\(icon!)"
            userAddRequest?.param = params
            // file
        }
        userAddRequest?.userAddInfoMeans()
        
    }
    
     // MARK: - 上传用户个人信息
    func uploadUserInfo(imageData: NSData, sex: Int, nick_name: String, city: String) {
        
        
        let str = "/api/user/editinfo"
        let params = "sex:\(sex),nick_name:\(nick_name),city:\(city)"
        
        var post         = [String: String]()
        post["type"]  = String(self.type)
        post["param"] = String(params)
    
        HttpRequest.sharedHttpRequest.upload(str, data: imageData, parameters: post) { (result, error) -> () in
            if error != nil {
                print("网络加载失败")
            }
            self.userInfoGain(self.type)
        }

    }
    
    /// MARK: - 保存和加载文件
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("account.plist")
    
    ///  将当前对象归档保存至沙盒 `Keyed` 键值归档/解档
    func saveAccount() {
        sharedUserAccount = self
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
        NSNotificationCenter.defaultCenter().postNotificationName(UserInfoChangeNotification, object: true)
    }
    
    
    class func loadAccount() -> UserAccount? {
        
        // 判断 token 是否已经过期，如果过期，直接返回 nil
        if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount {
        
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
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        nickname = aDecoder.decodeObjectForKey("nickname") as? String
        icon = aDecoder.decodeObjectForKey("icon") as? String
        gender = aDecoder.decodeIntegerForKey("gender") as Int
        city = aDecoder.decodeObjectForKey("city") as? String
        type = aDecoder.decodeIntegerForKey("type") as Int
    }
    
    ///  归档，aCoder 编码器，将对象转换成二进制数据保存到磁盘
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(nickname, forKey: "nickname")
        aCoder.encodeObject(icon, forKey: "icon")
        aCoder.encodeInteger(gender!, forKey: "gender")
        aCoder.encodeObject(city, forKey: "city")
        aCoder.encodeInteger(type, forKey: "type")
    }
}
