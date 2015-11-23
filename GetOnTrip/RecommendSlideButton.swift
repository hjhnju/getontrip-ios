//
//  RecommendSlideButton.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class RecommendSlideButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.ff_AlignInner(.CenterRight, referView: self, size: CGSizeMake(21, 14), offset: CGPointMake(-19, 0))
    }

}
