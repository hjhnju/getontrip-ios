//
//  UserAccount.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/5.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    /// 途知用户id(目前客户端不获取该id)
    var uid: Int = 0
    
    /// 用户标识
    var openid: String = ""
    
    /// 昵称
    var nickname: String = ""
    
    /// 头像
    var icon: String = ""
    
    /// 背景
    var bakimg: String = ""
    
    /// 性别
    var gender: Int = 0
    
    /// 城市
    var city: String = ""
    
    /// 邮箱
    var email: String = ""
    
    /// 原始数据
    var rawData: NSDictionary = NSDictionary()
    
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String = ""

    /// access_token的生命周期，单位是秒数(实际是数值！)
    var expires_in: NSTimeInterval = NSTimeInterval()

    /// 过期日期
    var expiresDate: NSDate = NSDate()
    
    /// 登录类型 1:qq,2:weixin,3:weibo
    var type: Int = 0
    
    /// 保存和加载文件
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("/account.plist")
    
    /// 第三方账号构造
    init(user: SSDKUser?, type: Int) {
        openid     = user?.uid ?? ""
        nickname   = user?.nickname ?? ""
        icon       = user?.icon ?? ""
        gender     = user?.gender.hashValue ?? 0
        rawData    = user?.rawData ?? NSDictionary()
        self.type  = type
        super.init()
    }
    
    /// email构造
    init(email: String, passwd: String){
        self.email = email
    }
    
    // MARK: - NSCoding 归档解档
    ///  解档，将保存在磁盘的二进制文件转换成 对象
    required init(coder aDecoder: NSCoder) {
        uid          = aDecoder.decodeObjectForKey("uid")          as? Int ?? 0
        access_token = aDecoder.decodeObjectForKey("access_token") as? String ?? ""
        expiresDate  = aDecoder.decodeObjectForKey("expiresDate")  as? NSDate ?? NSDate()
        openid       = aDecoder.decodeObjectForKey("openid")      as? String ?? ""
        nickname     = aDecoder.decodeObjectForKey("nickname")     as? String ?? ""
        icon         = aDecoder.decodeObjectForKey("icon")         as? String ?? ""
        gender       = aDecoder.decodeObjectForKey("gender")       as? Int    ?? 0
        city         = aDecoder.decodeObjectForKey("city")         as? String ?? ""
        type         = aDecoder.decodeIntegerForKey("type")        as  Int
        bakimg       = aDecoder.decodeObjectForKey("bakimg")      as? String ?? ""
    }
    
    ///  归档，aCoder 编码器，将对象转换成二进制数据保存到磁盘
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(openid, forKey: "openid")
        aCoder.encodeObject(nickname, forKey: "nickname")
        aCoder.encodeObject(icon, forKey: "icon")
        aCoder.encodeObject(gender, forKey: "gender")
        aCoder.encodeObject(city, forKey: "city")
        aCoder.encodeInteger(type, forKey: "type")
        aCoder.encodeObject(bakimg, forKey:  "bakimg")
    }
}
