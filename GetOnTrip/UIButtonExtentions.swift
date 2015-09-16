//
//  UIButtonExtentions.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class UIButtonExtentions: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK: - 收藏界面的按钮
class CollectButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let ix: CGFloat = self.bounds.width * 0.5
        let iy: CGFloat = self.bounds.height * 0.5 - 5
        let ty: CGFloat = self.bounds.height * 0.5 + 20
        imageView?.center = CGPointMake(ix, iy)
        titleLabel?.center = CGPointMake(ix, ty)
    }
    
}