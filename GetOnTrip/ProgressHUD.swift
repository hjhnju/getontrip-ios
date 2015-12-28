
//
//  ProgressHUD.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/27.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import JGProgressHUD

class ProgressHUD: NSObject {
    
    /// 创建单例对象
    static let sharedProgressHUD = ProgressHUD()
    
    /// 显示错误提示
    class func showErrorHUD(view: UIView?, text: String, var style: JGProgressHUDStyle? = .Dark) {
        
        if style == nil {
            style = .Dark
        }
        
        let hud = JGProgressHUD(style: style!)
        hud.textLabel.text = text
        hud.indicatorView = nil
        // 允许用户进行操作
        hud.interactionType = .BlockTouchesOnHUDView
        // 注释图标
        //        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        //        hud.square = true
        if view == nil {
            hud.showInView(UIApplication.sharedApplication().keyWindow)
        } else {
            hud.showInView(view)
        }
        hud.dismissAfterDelay(1.0)
    }
    
    // 显示成功提示
    class func showSuccessHUD(view: UIView?, text: String, var style: JGProgressHUDStyle? = .Dark) {
        
        if style == nil {
            style = .Dark
        }
        
        let hud = JGProgressHUD(style: style!)
        hud.textLabel.text = text
        hud.indicatorView = nil
        // 允许用户进行操作
        hud.interactionType = .BlockTouchesOnHUDView
        // 注释图标
        //        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        //        hud.square = true
        if view == nil {
            hud.showInView(UIApplication.sharedApplication().keyWindow)
        } else {
            hud.showInView(view)
        }
//                hud.position = JGProgressHUDPosition.Center
        //        hud.marginInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        hud.dismissAfterDelay(1.0)
    }
    
    /// 显示操作提示
    func showOperationPrompt(view: UIView?, text: String, var style: JGProgressHUDStyle?, handler: ((handler:(Void) -> Void) -> Void)? = nil) {
        
        if style == nil {
            style = .Dark
        }
        
        let hud = JGProgressHUD(style: style!)
        hud.textLabel.text = text
        // 注释图标
        hud.indicatorView = nil
        hud.position = JGProgressHUDPosition.Center
        hud.marginInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        if view == nil {
            hud.showInView(UIApplication.sharedApplication().keyWindow)
        } else {
            hud.showInView(view)
        }
        handler?() {
            hud.dismiss()
        }
    }
}
