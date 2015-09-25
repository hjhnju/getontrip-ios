//
//  UITextField+Extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

extension UITextField {
    
    convenience init(alignment: NSTextAlignment, sizeFout: CGFloat, color: UIColor) {
        self.init()
        
        textColor = color
        font = UIFont.systemFontOfSize(sizeFout)
        textAlignment = alignment
    }
}