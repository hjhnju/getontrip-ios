//
//  extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

extension UIView {
    
    convenience init(color: UIColor, alphaF: CGFloat = 1) {
        self.init()
        
        backgroundColor = color
        alpha = alphaF
    }
    
    /// 添加阴影
    func getShadowWithView() {
        
        layer.shadowColor = UIColor(hex: 0x000000, alpha: 0.1).CGColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0
        layer.shadowOffset = CGSizeMake(0, 1)
//        cell.layer.shadowPath = UIBezierPath(rect: cell.layer.frame).CGPath        
    }
}

