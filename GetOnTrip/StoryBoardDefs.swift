//
//  StorybordID.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

struct StoryBoardIdentifier {
    static let MainNavViewId = "MainNavViewID"
    static let MenuViewId    = "MenuViewID"
    static let LoginMenuViewId = "LoginMenuViewID"
    static let MenuCellId    = "MenuCellID"
    
    //segues
    static let ShowFavSegue  = "ShowFavSegue"
}


struct SceneColor {
    static let lightYellow = UIColor(hex: 0xF3FD54, alpha: 1)
    static let yellow = UIColor.yellowColor()
    static let black  = UIColor.blackColor()
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