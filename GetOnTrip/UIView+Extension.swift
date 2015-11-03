//
//  extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

extension UIView {
    
    convenience init(color: UIColor, alphaF: CGFloat = 1) {
        self.init()
        
        backgroundColor = color
        alpha = alphaF
    }
}

