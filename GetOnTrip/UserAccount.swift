//
//  UserAccount.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/5.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

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
    
    /// 获取用户信息请求
    /// 网络请求，加载数据
    var lastSuccessRequest: UserInfoRequest?
    
    /// 登陆类型
    var type: Int = 0
    init(user: SSDKUser, type: Int) {
        
        credential = user.credential
        uid        = user.uid
        nickname   = user.nickname
        icon       = user.icon
        gender     = user.gender.hashValue
        rawData    = user.rawData
        self.type  = type
        super.init()

        // MARK: - 用户信息创建完毕，即刻保存
        saveAccount()
    }
    
    /// MARK: - 保存和加载文件
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("account.plist")
    
    ///  将当前对象归档保存至沙盒 `Keyed` 键值归档/解档
    func saveAccount() {
        print(UserAccount.accountPath)
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
        
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
    
    private func loadUserData() {
        
        //获取数据更新tableview
//        if lastSuccessRequest == nil {
//            lastSuccessRequest = UserInfoRequest()
//        }
//        
//        lastSuccessRequest?.fetchBookModels { (handler: Topic) -> Void in
////           print(handler)
//        }
        
    }
    
    // MARK: - NSCoding 归档解档
    ///  解档，将保存在磁盘的二进制文件转换成 对象
    required init(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
//        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        nickname = aDecoder.decodeObjectForKey("nickname") as? String
        icon = aDecoder.decodeObjectForKey("icon") as? String
        gender = aDecoder.decodeIntegerForKey("gender") as Int
        city = aDecoder.decodeObjectForKey("city") as? String
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
    }
}
