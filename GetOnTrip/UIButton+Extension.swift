//
//  extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

// MARK: 扩展
extension UIButton {
    
    /// 快速设置圆角
    convenience init(icon: String) {
        
        self.init()
        setImage(UIImage(named: icon), forState: UIControlState.Normal)
        layer.cornerRadius = min(bounds.width, bounds.height) * 0.5
        layer.masksToBounds = true
    }
}

// MARK: - 收藏界面的按钮
class CollectButton: UIButton {
    
    convenience init(title: String, imageName: String, fontSize: CGFloat, titleColor: UIColor = UIColor.whiteColor()) {
        
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        setTitleColor(titleColor, forState: UIControlState.Normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let ix: CGFloat = bounds.width * 0.5
        let iy: CGFloat = bounds.height * 0.5 - 5
        let ty: CGFloat = bounds.height * 0.5 + 20
        imageView?.center = CGPointMake(ix, iy)
        titleLabel?.center = CGPointMake(ix, ty)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}