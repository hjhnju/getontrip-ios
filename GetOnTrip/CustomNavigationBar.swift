//
//  CustomNavigationBar.swift
//
//    //Example1: 普通导航add custom bar
//    let navBar = CustomNavigationBar(title: "普通导航", titleColor: nil, titleSize: nil)
//    navBar.frame = CGRectMake(0, 0, view.bounds.width, 64)
//    navBar.backgroundColor = UIColor.greenColor()
//    navBar.setBackBarButton(UIImage(named: "icon_back"), title:"途知", target: self, action: "backToMainAction:")
//    navBar.setRightBarButton(UIImage(named: "icon_back"), target: self, action: "backToMainAction:")
//
//    //Example2: 不带状态栏的导航并设置半透明效果
//    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
//    let navBar = CustomNavigationBar(title: "半透明模糊效果导航")
//    navBar.backgroundColor = UIColor.clearColor()
//    navBar.setStatusBarHidden(true)
//    navBar.setBackBarButton(UIImage(named: "icon_back"), title:"", target: self, action: "backToMainAction:")
//    navBar.setRightBarButton(UIImage(named: "icon_search"), target: self, action: "backToMainAction:")
//    navBar.setBlurViewEffect(UIColor.orangeColor(), alpha: 0.5)
//    self.view.addSubview(navBar)

//  Created by 何俊华 on 15/11/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationBar: UIView {
    
    var titleLabel: UILabel   = UILabel()
    
    var backButton: UIButton  = UIButton(type: UIButtonType.Custom)
    
    var rightButton: UIButton = UIButton(type: UIButtonType.Custom)
    
    var rightButton2: UIButton = UIButton(type: UIButtonType.Custom)
    
    lazy var blurView: UIVisualEffectView = {
        return UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        }()
    
    ///视图是否包括状态栏
    private var hasStatusBar: Bool = true {
        didSet {
            autolayoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(){
        super.init(frame: CGRectZero)
        initView()
    }
    
    convenience init(title: String?, titleColor: UIColor? = UIColor.whiteColor(), titleSize: CGFloat? = 18) {
        self.init()
        
        initView()
        
        self.titleLabel.text = title
        self.titleLabel.textColor = titleColor
        self.titleLabel.font = UIFont.systemFontOfSize(titleSize ?? 18)
    }
    
    private func initView() {
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
        
        setBlurViewEffectColor()
        
        //title label
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.textAlignment   = NSTextAlignment.Center
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(self.titleLabel)
        
        //back button
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.addSubview(self.backButton)
        
        //right button
        self.rightButton.translatesAutoresizingMaskIntoConstraints = false
        self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        self.addSubview(self.rightButton)
        
        self.rightButton2.translatesAutoresizingMaskIntoConstraints = false
        self.rightButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        self.addSubview(self.rightButton2)
        
        setButtonTintColor()
        
        //layout subviews
        autolayoutSubviews()
    }
        
    /// 布局
    func autolayoutSubviews() {
        //有状态栏情况下的导航
        let width: CGFloat  = UIScreen.mainScreen().bounds.size.width
        let height: CGFloat = self.hasStatusBar ? 64 : 44
        
        self.frame = CGRectMake(0, 0, width, height)
        blurView.frame = self.bounds
        
        let metric = ["width": width, "height": height, "navbarHeight": 44, "backButtonWidth": 80, "rightButtonWidth": 53]
        let viewsBindings = ["titleLabel": titleLabel, "backButton": backButton, "rightButton": rightButton, "rightButton2": rightButton2]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[titleLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel(navbarHeight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backButton(backButtonWidth)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[backButton(navbarHeight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[rightButton(rightButtonWidth)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[rightButton(navbarHeight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[rightButton2(rightButtonWidth)]-(rightButtonWidth)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[rightButton2(navbarHeight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metric, views: viewsBindings))
    }
    
    //MARK: 常用接口
    
    /// 设置是否有状态栏
    /// 如需设置，该方法要求在其他自定义设置方法前调用，以保证frame准确计算
    func setStatusBarHidden(hidden: Bool) {
        self.hasStatusBar = !hidden
    }
    
    /// 设置导航标题
    func setTitle(title: String?) {
        self.titleLabel.text = title
    }
    
    /// 设置导航的barTintColor
    func setButtonTintColor(color: UIColor = UIColor.grayColor()){
        //图片+文字
        self.backButton.tintColor = color
        self.backButton.setTitleColor(color, forState: UIControlState.Normal)
        self.backButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.rightButton.tintColor = color
        self.rightButton.setTitleColor(color, forState: UIControlState.Normal)
        self.rightButton.imageView?.frame = CGRectMake(0, 0, 21, 20)
        self.rightButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.rightButton2.tintColor = color
        self.rightButton2.setTitleColor(color, forState: UIControlState.Normal)
        self.rightButton2.imageView?.frame = CGRectMake(0, 0, 21, 20)
        self.rightButton2.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    /// 设置返回按钮
    func setBackBarButton(icon: UIImage?, title: String?, target: AnyObject?, action: Selector){
        self.backButton.hidden = false
        if let image = icon {
            self.backButton.setImage(image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
            self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2 + image.size.width, 0, 0)
        } else {
            self.backButton.setImage(nil, forState: UIControlState.Normal)
            self.backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        }
        self.backButton.setTitle(title, forState: UIControlState.Normal)
        self.backButton.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /// 设置右侧按钮
    func setRightBarButton(icon: UIImage?, title: String?, target: AnyObject?, action: Selector){
        self.rightButton.hidden = false
        if let image = icon {
            self.rightButton.setImage(image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
            self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9 + 2)
            self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9)
        } else {
            self.rightButton.setImage(nil, forState: UIControlState.Normal)
            self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9)
        }
        self.rightButton.setTitle(title, forState: UIControlState.Normal)
        self.rightButton.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /// 设置右侧第二按钮
    func setRight2BarButton(icon: UIImage?, title: String?, target: AnyObject?, action: Selector){
        self.rightButton2.hidden = false
        if let image = icon {
            self.rightButton2.setImage(image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
            self.rightButton2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9 + 2)
            self.rightButton2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9)
        } else {
            self.rightButton2.setImage(nil, forState: UIControlState.Normal)
            self.rightButton2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9)
        }
        self.rightButton2.setTitle(title, forState: UIControlState.Normal)
        self.rightButton2.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /// 设置半透明模糊背景
    func setBlurViewEffectColor(color: UIColor? = nil, alpha: CGFloat? = nil) {
        let color = color ?? UIColor.whiteColor()
        let alpha = alpha ?? 0.5
        blurView.contentView.backgroundColor = color
        blurView.contentView.alpha = alpha
    }
    
    func setBlurViewEffect(effect: Bool) {
        blurView.hidden = !effect
    }
}
