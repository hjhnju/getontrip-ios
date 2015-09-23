//
//  extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

extension UIView {
    
    convenience init(color: UIColor, alphaF: CGFloat = 1) {
        self.init()
        
        backgroundColor = color
        alpha = alphaF
    }
    
//    convenience init(color: UIColor, ) {
//        let baselineView = UIView()
//        baselineView.backgroundColor = UIColor(white: 0xFFFFFF, alpha: 0.3)
//        cell.addSubview(baselineView)
//    }
}
