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

class shareButton : UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.textAlignment = NSTextAlignment.Center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRectMake(0, 0, 50, 50)
        titleLabel?.bounds = CGRectMake(0, 0, 50, 20)
        titleLabel?.center = CGPointMake(25, bounds.height - 10)
    }
}

class homeSightButton : UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w: CGFloat = 8
        let h: CGFloat = 14.85
        imageView?.frame = CGRectMake(bounds.width - 10 - w, (bounds.height - h) * 0.5, w, h)
    }
}