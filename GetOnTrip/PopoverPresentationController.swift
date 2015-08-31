//
//  PopoverPresentationController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
   
    // 展现视图的 frame
    var presentFrame = CGRectZero
    
    // 遮罩视图
    lazy var dummyView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: "close")
        v.addGestureRecognizer(tap)
        
        return v
    }()
    
    //  关闭展现视图控制器
    func close() {
        
        presentedViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
        NSNotificationCenter.defaultCenter().postNotificationName("navigationChangeTitle", object: nil)
        })
    }
    
    //  容器视图将要重新布局子视图
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 添加并且设置 dummyView
        dummyView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
        containerView?.insertSubview(dummyView, atIndex: 0)
        
        // 设置视图大小
        presentedView()?.frame = presentFrame
    }
}

