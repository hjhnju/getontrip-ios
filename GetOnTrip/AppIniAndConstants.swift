//
//  StorybordID.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

let GetonTripCn = "www.getontrip.cn"

class AppIniOnline {
    static let BaseUri = "http://123.57.67.165:8301"
}

class AppIniDev {
    static let BaseUri = "http://123.57.46.229:8301"
}

class AppIni:AppIniDev {
    static let ImageSliceMultipler:CGFloat = 3
}


struct StoryBoardIdentifier {
    //menu
    static let MenuTableViewCellID = "MenuTableViewCellID"
    
    //search
    static let SearchRecommendTableViewCellID = "SearchRecommendTableViewCellID"
    
    //city
    static let CityHotTopicTableViewCellID   = "CityHotTopicTableViewCellID"
    static let CitySightCollectionViewCellID = "CitySightCollectionViewCellID"
    
}

struct SceneColor {
    static let lightYellow = UIColor(hex: 0xF3FD54, alpha: 1)
    
    //背景黑
    static let bgBlack     = UIColor(hex: 0x2A2D2E, alpha:1)
    //前景深黑
    static let frontBlack   = UIColor(hex: 0x1C1C1C, alpha: 1)
    
    
    static let gray        = UIColor(hex: 0x3E3E3E, alpha:1)
    static let lightGray   = UIColor(hex: 0x9C9C9C, alpha:1)
    
    static let white        = UIColor.whiteColor()
    static let crystalWhite = UIColor(hex: 0xFFFFFF, alpha:0.4)
    /// 白色首页话题副标题文字颜色
    static let whiteGrey   = UIColor(hex: 0x939393, alpha: 1.0)
    /// 浅白 设置界面选择城市及性别pickView
    static let shallowWhite = UIColor(hex: 0xDCD7D7, alpha: 1.0)
    /// 浅灰
    static let shallowGrey = UIColor(hex: 0x979797, alpha: 1.0)
    /// 深灰
    static let deepGrey    = UIColor(hex: 0x1F2122, alpha: 1.0)
    
    /// 696969 评论内容
    static let dilutedGrey   = UIColor(hex: 0x696969, alpha: 1.0)
    /// F3FD54 浅黄
    static let shallowYellows = UIColor(hex: 0xF3FD54, alpha: 1.0)
}

///  登陆类型 1:qq,2:weixin,3:weibo
struct LoginType {
    /// 1
    static let qqLogin     = 1
    /// 2
    static let weixinLogin = 2
    /// 3
    static let weiboLogin  = 3
}


struct categoryLabel {
    /// 5
    static let sightLabel = 5
    /// 6
    static let videoLabel = 6
    /// 7
    static let bookLabel  = 7
}

struct SceneFont {
    static let heiti = "STHeitiSC-Light"
}

/// 占位图像
struct placeholderImage {
    static let userIcon = "user_icon"
}