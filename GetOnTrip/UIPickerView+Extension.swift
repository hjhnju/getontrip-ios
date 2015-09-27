
//
//  UIPickerView+Extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

extension UIPickerView {
    
    /**
    快速创建pickView
    
    - parameter color: 背影颜色
    - parameter hidde: 是否隐藏，默认显示
    
    - returns: pickView
    */
    convenience init(color: UIColor, hidde: Bool = false) {
        self.init()
        
        backgroundColor = color
        hidden = hidde 
    }
}