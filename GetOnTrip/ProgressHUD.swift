
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
    
    class func showErrorHUD(view: UIView?, text: String, style: JGProgressHUDStyle = JGProgressHUDStyle.ExtraLight) {
        
        let hud = JGProgressHUD(style: style)
        hud.textLabel.text = text
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.square = true
        if view == nil {
            hud.showInView(UIApplication.sharedApplication().keyWindow)
        } else {
            hud.showInView(view)
        }
        hud.dismissAfterDelay(3.0)
    }
    
    class func showSuccessHUD(view: UIView?, text: String, style: JGProgressHUDStyle = JGProgressHUDStyle.ExtraLight) {
        
        let hud = JGProgressHUD(style: style)
        hud.textLabel.text = text
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.square = true
        if view == nil {
            hud.showInView(UIApplication.sharedApplication().keyWindow)
        } else {
            hud.showInView(view)
        }
        hud.dismissAfterDelay(3.0)
    }
    
}
