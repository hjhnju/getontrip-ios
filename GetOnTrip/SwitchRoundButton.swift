//
//  SwitchRoundButton.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SwitchRoundButton: UIButton {

    /// imageview 需要改变到什么样的frame
    var imageViewFrame: CGRect = CGRectZero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = imageViewFrame
    }

}
