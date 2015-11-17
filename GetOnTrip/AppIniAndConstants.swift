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

class AppIni:AppIniOnline {
    static let Domain:String = "www.getontrip.cn"
    static let SecretKey: String = "ahl93##41cfw!@23"
}

struct SceneColor {
    static let lightYellow = UIColor(hex: 0xF3FD54, alpha: 1)
    //背景黑
    static let bgBlack     = UIColor(hex: 0x2A2D2E, alpha:1)
    //前景深黑
    static let frontBlack   = UIColor(hex: 0x1C1C1C, alpha: 1)
    
    static let gray        = UIColor(hex: 0x3E3E3E, alpha:1)
    static let lightGray   = UIColor(hex: 0x9C9C9C, alpha:1)
    
    static let white        = UIColor(hex: 0xFFFFFF, alpha: 1)
    static let crystalWhite = UIColor(hex: 0xFFFFFF, alpha:0.4)
    /// 白色首页话题副标题文字颜色
    static let grayWhite   = UIColor(hex: 0x939393, alpha: 1.0)
    /// 浅白 设置界面选择城市及性别pickView
    static let shallowWhite = UIColor(hex: 0xDCD7D7, alpha: 1.0)
    /// 979797 浅灰
    static let shallowGrey = UIColor(hex: 0x979797, alpha: 1.0)
    /// 深灰
    static let deepGrey    = UIColor(hex: 0x1F2122, alpha: 1.0)
    
    /// 696969 评论内容
    static let fontGray = UIColor(hex: 0x696969, alpha: 1.0)
    /// F3FD54 浅黄
    static let shallowYellows = UIColor(hex: 0xF3FD54, alpha: 1.0)
    /// D8D8D8
    static let whiteGray = UIColor(hex: 0xD8D8D8, alpha: 1.0)
    /// 5C5C5C
    static let thinGray  = UIColor(hex: 0x5C5C5C, alpha: 1.9)
}

struct SceneFont {
    static let heiti = "STHeitiSC-Light"
}

/// 占位图像
struct PlaceholderImage {
    static let userIcon = "user_icon"
    static let defaultSmall = UIImage(named: "default_small")
    static let defaultLarge = UIImage(named: "default_large")
}

struct MessageInfo {
    static let REQUEST_ERR_RETURN = "请求失败，请检查您的网络设置"
}