//
//  CommentButton.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CommentButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.bounds = CGRectMake(0, 0, 28, 28)
        titleLabel?.frame = CGRectMake(0, 0, 28, 25)
        titleLabel?.textAlignment = NSTextAlignment.Center
    }
}
