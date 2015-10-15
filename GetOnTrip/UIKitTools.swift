//
//  UIKitTools.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class UIKitTools {
    
    class func getNavBackView(navBar: UINavigationBar?) -> UIView? {
        if let superView = navBar {
            for view in superView.subviews {
                if view.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!) {
                    return view
                }
            }
        }
        return nil
    }
}