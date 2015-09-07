//
//  SendPresentationController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SendPresentationController: UIPresentationController {
    
    /// 展现视图的 frame
    var presentFrame = CGRectZero
    
    /// 遮罩视图
    lazy var dummyView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        
        let tap = UITapGestureRecognizer(target: self, action: "close")
        v.addGestureRecognizer(tap)
        
        return v
    }()
    
    ///  关闭展现视图控制器
    func close() {
        
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            self.presentedViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    ///  容器视图将要重新布局子视图
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 添加并且设置 dummyView
        dummyView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        containerView?.insertSubview(dummyView, atIndex: 0)
        
        // 设置视图大小
        presentedView()?.frame = presentFrame
    }
}

class SendPopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    /// 展现视图的大小
    var presentFrame = CGRectZero
    
    /// 是否展现的标记
    var isPresented = false
    
    // 返回负责转场的控制器对象
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let pc = SendPresentationController(presentedViewController: presented, presentingViewController: presenting)
        
        pc.presentFrame = presentFrame
        
        return pc
    }
    
    // 返回提供 Modal 动画的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    // 返回提供 Dismissed 动画的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
    
    // 动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        
        return isPresented ? 0.8 : 0.25
    }
    

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 判断是展现还是 dismiss
        if isPresented {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            // 1. 将 toView 添加到容器视图
            transitionContext.containerView().addSubview(toView)
            
            // 2. 动画实现
            toView.transform = CGAffineTransformMakeScale(1.0, 0)
            toView.layer.anchorPoint = CGPoint(x: 0, y: 1)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                toView.transform = CGAffineTransformIdentity
                
                }, completion: { (_) -> Void in
                    // 3. *** 结束动画 - 告诉系统转场动画已经结束
                    transitionContext.completeTransition(true)
            })
        } else {
            // 1. 取消 － fromView 删除
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                fromView.transform = CGAffineTransformMakeScale(1.0, 0.0001)
                }, completion: { (_) -> Void in
                    
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }
}