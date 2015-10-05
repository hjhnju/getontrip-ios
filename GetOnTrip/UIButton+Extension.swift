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
    convenience init(icon: String, masksToBounds: Bool = false) {
        
        self.init()
        setImage(UIImage(named: icon), forState: UIControlState.Normal)
        
        if masksToBounds == true {
            layer.cornerRadius = min(bounds.width, bounds.height) * 0.5
            layer.masksToBounds = false
        }
    }
    
    /// 快速设置文字
    convenience init(title: String, fontSize: CGFloat, radius: CGFloat, titleColor: UIColor = UIColor.whiteColor()) {
        
        self.init()
        setTitle(title, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        setTitleColor(titleColor, forState: UIControlState.Normal)
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// 快速设置文字
    convenience init(image: String, title: String, fontSize: CGFloat, titleColor: UIColor = UIColor.whiteColor()) {
        
        self.init()
        
        setImage(UIImage(named: image), forState: UIControlState.Normal)
        setTitle(title, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        setTitleColor(titleColor, forState: UIControlState.Normal)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let ix: CGFloat = bounds.width * 0.5
        let iy: CGFloat = bounds.height * 0.5 - 9
        let ty: CGFloat = bounds.height * 0.5 + 16
        imageView?.center = CGPointMake(ix, iy)
        titleLabel?.center = CGPointMake(ix, ty)
    }
}