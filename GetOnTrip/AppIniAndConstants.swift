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
    static let BaseUri = "http://123.57.67.165:8301"
}

class AppIniDev {
    static let BaseUri = "http://123.57.46.229:8301"
}

class AppIni:AppIniDev {
}

struct StoryBoardIdentifier {
    
    //menu
    static let MainNavViewID = "MainNavViewID"
    static let MenuViewID    = "MenuViewID"
    static let MenuCellID    = "MenuCellID"
    
    //nearby
    static let NearbyTableViewCellID = "NearbyTableViewCellID"
    static let NearbyHeaderViewID    = "NearbyHeaderViewID"
    static let TopicDetailViewControllerID = "TopicDetailViewControllerID"
    static let TopicDetailNavViewControllerID = "TopicDetailNavViewControllerID"
    
    //discovery
    static let DiscoveryViewCellID = "DiscoveryViewCellID"
    static let DiscoveryControllerID = "DiscoveryControllerID"
    
    //theme
    static let ThemeTabelViewCellID = "ThemeTabelViewCellID"
    static let ThemeTableViewControllerID = "ThemeTableViewControllerID"
    static let LandscapeCollectionViewCellID = "LandscapeCollectionViewCellID"
    
    //man page
    static let NearbyControllerID = "NearbyControllerID"
    static let SearchResultsCell  = "SearchResultsCell"
    static let SearchResultsViewControllerID = "SearchResultsViewControllerID"
    
    //segues
    static let ShowFavSegue         = "ShowFavSegue"
    static let ShowTopicDetailSegue = "ShowTopicDetailSegue"
    static let ShowSightTopicsSegue = "ShowSightTopicsSegue"
    static let ShowCitySightsSegue = "ShowCitySightsSegue"
    static let ShowDiscoveryTopicDetailSegue = "ShowDiscoveryTopicDetailSegue"
    static let ShowThemeSegue = "ShowThemeSegue"
    static let ShowLandscapeSegue = "ShowLandscapeSegue"
    
    //左侧菜单
    static let SideslipSwitchCity  = "SideslipSwitchCity"
    static let SidesMessage        = "SidesMessage"
    static let SidesSetting        = "SidesSetting"
    static let SidesFeedback       = "SidesFeedback"
    
    // storyboardID 附近二级页面
    static let ScenicCyclopaedicSB = "ScenicCyclopaedicSB"
    static let ScenicTopicSB       = "ScenicTopicSB"
    static let ScenicBookSB        = "ScenicBookSB"
    static let ScenicVideoSB       = "ScenicVideoSB"
    
    // 收藏页面
    static let CollectTopicSB      = "CollectTopicSB"
    static let CollectSightSB      = "CollectSightSB"
    static let CollectMotifSB      = "CollectMotifSB"
}

struct SceneColor {
    static let lightYellow = UIColor(hex: 0xF3FD54, alpha: 1)
    static let yellow      = UIColor.yellowColor()
    
    static let black       = UIColor.blackColor()
    static let lightBlack  = UIColor(hex: 0x2A2D2E, alpha:1)
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
    /// 首页热门景点底灰
    static let sightGrey   = UIColor(hex: 0x2A2D2E, alpha: 1.0)
    /// 首页底色
    static let homeGrey    = UIColor(hex: 0x1F2223, alpha: 1.0)
}

struct SceneFont {
    static let heiti = "STHeitiSC-Light"
}

/// 占位图像
struct placeholderImage {
    static let userIcon = "user_icon"
}

/// 侧滑角度
struct sideViewFrame {
    static let sideOffsetX = UIScreen.mainScreen().bounds.width * 0.75
}
