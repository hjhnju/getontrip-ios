//
//  CustomNavigationBar.swift
//  TestTransitioning
//
//  Created by 何俊华 on 15/11/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationBar: UIView {
    
    var titleLabel: UILabel!
    
    var backButton: UIButton!
    
    var rightButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(title: String, titleColor: UIColor?, titleSize: CGFloat?) {
        self.init()
        
        //title label
        self.titleLabel = UILabel()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font      = UIFont.systemFontOfSize(titleSize ?? 14)
        self.titleLabel.textColor = titleColor ?? UIColor.whiteColor()
        self.titleLabel.textAlignment   = NSTextAlignment.Center
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.text = title
        self.addSubview(self.titleLabel)
        
        //back button
        self.backButton = UIButton(type: UIButtonType.Custom)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.addSubview(self.backButton)
        
        //right button
        self.rightButton = UIButton(type: UIButtonType.Custom)
        self.rightButton.translatesAutoresizingMaskIntoConstraints = false
        self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        self.addSubview(self.rightButton)
        
        //layout subviews
        autolayoutSubviews()
    }
    
    /// 布局
    func autolayoutSubviews() {
        //有状态栏情况下的导航
        let metric = ["width": UIScreen.mainScreen().bounds.size.width, "height": 64, "navbarHeight": 44, "backButtonWidth": 80, "rightButtonWidth": 44]
        let viewsBindings = ["titleLabel": titleLabel, "backButton": backButton, "rightButton": rightButton]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[titleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[titleLabel(navbarHeight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backButton(backButtonWidth)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[backButton(navbarHeight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[rightButton(rightButtonWidth)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[rightButton(navbarHeight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
    }
    
    //MARK: 常用接口
    
    /// 设置返回按钮
    func setBackBarButton(icon: UIImage?, title: String?, target: AnyObject?, action: Selector){
        self.backButton.hidden = false
        if let image = icon {
            self.backButton.setImage(image, forState: UIControlState.Normal)
            self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2 + image.size.width, 0, 0)
        }
        self.backButton.setTitle(title ?? "", forState: UIControlState.Normal)
        self.backButton.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /// 设置右侧按钮
    func setRightBarButton(icon: UIImage?, target: AnyObject?, action: Selector){
        self.rightButton.hidden = false
        if let image = icon {
            self.rightButton.setImage(image, forState: UIControlState.Normal)
            self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9)
        }
        self.rightButton.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    }
}
