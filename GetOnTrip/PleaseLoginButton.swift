//
//  PleaseLoginButton.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

/// 请登陆按钮
class PleaseLoginButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.layer.cornerRadius = min(imageView!.frame.width, imageView!.frame.height) * 0.5
        imageView?.clipsToBounds = true
        
        imageView?.center = CGPointMake(frame.width * 0.5, frame.height * 0.5)
        titleLabel?.center = CGPointMake(imageView!.center.x, CGRectGetMaxY(imageView!.frame) + titleLabel!.frame.height * 0.5 + 10)
    }
}
