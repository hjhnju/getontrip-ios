

//
//  ControllerTools.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/27.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

/// 有关于控制器的方法
class ControllerTools: UIView {

    ///  得到它自己的父控制器
    ///
    ///  - returns: 它自己的父控制器
    class func parentViewController(view: UIView, viewController: String) -> UIViewController? {
        for var next = view.superview; (next != nil); next = next?.superview {
            let nextResponder = next?.nextResponder()
            if ((nextResponder?.isKindOfClass(NSClassFromString("GetOnTrip.\(viewController)")!)) != nil) {
                return nextResponder as? UIViewController
            }
        }
        return nil
    }

}
