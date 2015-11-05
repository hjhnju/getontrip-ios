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
    
    //获取导航有效着色背景
    class func getNavBackView(navBar: UINavigationBar?) -> UIView? {
        var backView:UIView? = nil
        if let superView = navBar {
            for view in superView.subviews {
                if view.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!) {
                    backView = view
                }
                if view.isKindOfClass(NSClassFromString("_UIBackdropView")!) {
                    view.hidden = true
                }
            }
        }
        return backView
    }
    
    //获得颜色图片
    class func imageWithColor(color: UIColor) -> UIImage {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let ref = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(ref, color.CGColor)
        CGContextFillRect(ref, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 获取压缩图片的URL
    class func sliceImageUrl(path:String, width: Int, height: Int) -> String {
        //重要：若已经是压缩图片的格式则什么都不做，直接返回
        if path.containsString("@") {
            return path
        }
        let url = "\(AppIni.BaseUri)\(path)@e\(width)w_e\(height)h"
        return url
    }
}