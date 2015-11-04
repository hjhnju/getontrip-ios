//
//  BaseViewController.swift
//  TestTransitioning
//
//  Created by 何俊华 on 15/11/3.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CustAnimateViewController: BaseViewController, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var animator = CBStoreHouseTransitionAnimator()
    var interactiveTransition: CBStoreHouseTransitionInteractiveTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("BaseViewController:viewDidAppear")
        self.navigationController?.delegate = self;
        self.interactiveTransition = CBStoreHouseTransitionInteractiveTransition()
        self.interactiveTransition.attachToViewController(self)
        
        self.transitioningDelegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("BaseViewController:viewWillDisappear")
        if navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: navigationController代理
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case UINavigationControllerOperation.Push:
            self.interactiveTransition = nil;
            self.animator.type = AnimationTypePush
            return self.animator
        case UINavigationControllerOperation.Pop:
            self.animator.type = AnimationTypePop
            return self.animator
        default:
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactiveTransition
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //self.interactiveTransition = nil;
        self.animator.type = AnimationTypePush
        return self.animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.type = AnimationTypePop
        return self.animator
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactiveTransition
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactiveTransition
    }
    
    // MARK: 自定义方法
    
    override func popViewAction(sender: UIButton) {
        super.popViewAction(sender)
        self.interactiveTransition = nil;
    }
    
}
