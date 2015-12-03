//
//  StorybordID.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class AppIniOnline {
    static let BaseUri = "http://www.getontrip.cn"
    static let BaseResourceUri = "http://static.getontrip.cn"
}

class AppIniDev {
    static let BaseUri = "http://123.57.46.229:8301"
    static let BaseResourceUri =  "http://123.57.46.229:8301"
}

class AppIni:AppIniDev  {
    static let Domain:String      = "www.getontrip.cn"
    static let SecretKey: String  = "ahl93##41cfw!@23"
    static let ApiVersion: String = "1.0"
    
    /// 是否直接使用未过期的缓存，并不再发送相同的数据请求
    static let UseValidCache: Bool = true
}

struct SceneColor {
    
    /**
    黄色系列 
    */
    static let lightYellow = UIColor(hex: 0xF3FD54, alpha: 1)
    /// 浅黄
    static let shallowYellows = UIColor(hex: 0xF3FD54, alpha: 1.0)
    static let darkYellows = UIColor(hex: 0xF3FC51, alpha: 1.0)
    
    /** 
    黑色系列
    */
    /// 背景黑
    static let bgBlack      = UIColor(hex: 0x2A2D2E, alpha:1)
    /// 前景深黑
    static let frontBlack   = UIColor(hex: 0x1C1C1C, alpha: 1)
    
    /**
    灰色系列 
    */
    static let gray        = UIColor(hex: 0x3E3E3E, alpha:1)
    static let lightGray   = UIColor(hex: 0x9C9C9C, alpha:1)
    static let shallowGrey = UIColor(hex: 0x979797, alpha: 1.0)
    static let deepGrey    = UIColor(hex: 0x1F2122, alpha: 1.0)
    static let fontGray    = UIColor(hex: 0x696969, alpha: 1.0)
    static let thinGray    = UIColor(hex: 0x5C5C5C, alpha: 1.9)
    static let lightgrey   = UIColor(hex: 0xB8B8B8, alpha: 1.0)
    static let darkgray    = UIColor(hex: 0x5D5D5D, alpha: 0.5)
    static let lightGrayEM = UIColor(hex: 0x474747, alpha: 1.0)
    static let lightgrayCM = UIColor(hex: 0xA6A6A6, alpha: 0.2)
    
    /**
    白色系列
    */
    static let white       = UIColor(hex: 0xFFFFFF, alpha: 1)
    static let grayWhite   = UIColor(hex: 0x939393, alpha: 1.0)
    static let shallowWhite = UIColor(hex: 0xDCD7D7, alpha: 1.0)
    static let whiteGray = UIColor(hex: 0xD8D8D8, alpha: 1.0)
    
    /**
    彩色系列
    */
    static let lightblue   = UIColor(hex: 0x2BB3E0, alpha: 1.0)
}

struct SceneFont {
    static let heiti = "STHeitiSC-Light"
}

/// 占位图像
struct PlaceholderImage {
    static let userIcon = "user_icon"
    static let defaultSmall = UIImage(named: "default_small")
    static let defaultLarge = UIImage(named: "default_large")
    static let defaultUser  = UIImage(named: "icon_app")
}

struct MessageInfo {
    static let REQUEST_ERR_RETURN = "请求失败，请检查您的网络设置"
}

/// 正则抓取包含字母和数字
struct Regular {
    static let letterAndNum = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@."
}

/// 字体
struct Font {
    static let defaultFont = "PingFangTC-Light"
}