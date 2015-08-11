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

class AppIni:AppIniOnline {
}

struct StoryBoardIdentifier {
    
    //menu
    static let MainNavViewID = "MainNavViewID"
    static let MenuViewID    = "MenuViewID"
    static let MenuCellID    = "MenuCellID"
    
    //nearby
    static let NearbyTableViewCellID = "NearbyTableViewCellID"
    static let NearbyHeaderViewID    = "NearbyHeaderViewID"
    
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
    static let lightBlack = UIColor(hex: 0x1C1C1C, alpha:1)
}

extension UIColor {
    
    convenience init(hex: UInt, alpha: CGFloat){
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}