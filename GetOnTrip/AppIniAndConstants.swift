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
    //man page
    static let NearbyControllerID = "NearbyControllerID"
    static let SearchResultsCell  = "SearchResultsCell"
    static let SearchResultsViewControllerID = "SearchResultsViewControllerID"
    
    //segues
    static let ShowFavSegue  = "ShowFavSegue"
    static let ShowTopicDetailSegue = "ShowTopicDetailSegue"
    static let ShowSightTopicsSegue = "ShowSightTopicsSegue"
    static let ShowCitySightsSegue = "ShowCitySightsSegue"
}

struct SceneColor {
    static let lightYellow = UIColor(hex: 0xF3FD54, alpha: 1)
    static let yellow = UIColor.yellowColor()
    
    static let black  = UIColor.blackColor()
    static let lightBlack = UIColor(hex: 0x2A2D2E, alpha:1)
    static let lightGray = UIColor(hex: 0x9C9C9C, alpha:1)
    
    static let white  = UIColor.whiteColor()
    static let crystalWhite = UIColor(hex: 0xFFFFFF, alpha:0.4)
}

struct SceneFont {
    static let heiti = "STHeitiSC-Light"
}