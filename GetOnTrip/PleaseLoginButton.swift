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
        
        imageView?.bounds = CGRectMake(0, 0, 90, 90)
        imageView?.layer.cornerRadius = min(imageView!.frame.width, imageView!.frame.height) * 0.5
    }
}
