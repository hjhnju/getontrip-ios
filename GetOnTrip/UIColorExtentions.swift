//
//  UIColorExtentions.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/15.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex: UInt, alpha: CGFloat){
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}