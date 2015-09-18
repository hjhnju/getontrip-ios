//
//  PopoverAnimator.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    /// 展现视图的大小
    var presentFrame = CGRectZero
    
    /// 是否展现的标记
    var isPresented = false
    
    // 返回负责转场的控制器对象
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        
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
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return isPresented ? 1.2 : 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        if isPresented {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            transitionContext.containerView()!.addSubview(toView)
            
            
            toView.transform = CGAffineTransformMakeScale(1.0, 0)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                toView.transform = CGAffineTransformIdentity
                
                }, completion: { (_) -> Void in
            
                    transitionContext.completeTransition(true)
            })
        } else {
            
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