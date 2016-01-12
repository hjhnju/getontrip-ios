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
    static let BaseUri = "http://123.57.46.229:8301" // 8301
    static let BaseResourceUri =  "http://123.57.46.229:8301" // 8301
}

class AppIni:AppIniOnline {
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
    static let frontBlackFour = UIColor(hex: 0x1C1C1C, alpha: 0.4)
    /// 透明度为0.6
    static let frontBlackSix   = UIColor(hex: 0x1C1C1C, alpha: 0.6)
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
    static let darkGrey    = UIColor(hex: 0xC8C7CC, alpha: 1.0)
    static let greyWhite   = UIColor(hex: 0xF7F5F3, alpha: 1.0)
    static let thinGrey    = UIColor(hex: 0x757575, alpha: 1.0)
    static let whiteGrey   = UIColor(hex: 0x7F7F7F, alpha: 0.5)
    static let greyThin    = UIColor(hex: 0xF0F0F0, alpha: 1.0)
    static let shallowWhiteGrey = UIColor(hex: 0x9F9F9F, alpha: 1.0)
    static let greyThinWhite = UIColor(hex: 0xBDBDBD, alpha: 1.0)
    
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
    static let thinGreen   = UIColor(hex: 0x3E5C3A, alpha: 1.0)
    
    static func randomColor() -> UIColor {
        /*
        let color1:CGFloat = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let color2:CGFloat = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let color3:CGFloat = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        return UIColor(red: color1, green: color2, blue: color3, alpha: 0.5)
        */
        return UIColor.randomColor().colorWithAlphaComponent(0.5)
    }
}

struct SceneFont {
    static let heiti = "STHeitiSC-Light"
}

struct Frame {
    static let screen = UIScreen.mainScreen().bounds
}

/// 占位图像
struct PlaceholderImage {
    static let userIcon = "user_icon"
    static let defaultSmall = UIImage(named: "default_small")
    static let defaultUser  = UIImage(named: "icon_app")
}

struct MessageInfo {
    static let NetworkError = "您的网络无法连接"
}

/// 正则抓取包含字母和数字
struct Regular {
    static let letterAndNum = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@."
}

/// 字体
struct Font {
    static let defaultFont       = "PingFangTC-Light"
    static let PingFangTCThin    = "PingFangTC-Thin"
    static let HelveticaNeueThin = "HelveticaNeue-Thin"
    static let PingFangSCRegular = "PingFangSC-Regular"
    static let PingFangSCLight   = "PingFangSC-Light"
    static let ios8Font          = ".HelveticaNeueInterface-Light"
    static let PingFangTCMedium  = "PingFangTC-Medium"
//    static let HelveticaNeueThin
}

struct Event {
    /// 首页搜索框被点击
    static let home_click_searchBar_eid           = "home_click_searchBar_eid"
    /// 首页点击话题详情页
    static let home_click_topicViewController_eid = "home_click_topicViewController_eid"
    /// 首页点击城市页面
    static let home_click_cityViewController_eid  = "home_click_cityViewController_eid"
    /// 首页点击景点页面
    static let home_click_sightViewController_eid = "home_click_sightViewController_eid"
    /// 首页点击菜单按钮
    static let home_click_menuViewController_eid  = "home_click_menuViewController_eid"
    /// 首页菜单显示次数
    static let home_show_menuViewController_eid    = "home_show_menuViewController_eid"
    /// 点赞事件
    static let praise_eventid  = "praise_eventid"
    /// 收藏事件
    static let collect_eventid = "collect_eventid"
    /// 评论事件
    static let comment_eventid = "comment_eventid"
}