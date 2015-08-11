//
//  MasterViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/30.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

//所有SlideMenuViewController的右侧控制器的父类
class MasterViewController: UINavigationController {
    
    //MASK: Properties
    
    var slideDelegate: SlideMenuViewControllerDelegate?
    
    var maskView: UIView!
    
    //用户拖动视图
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    
    //MASK: View Life Cycle
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //统一navbar颜色样式
        self.navigationBar.tintColor    = SceneColor.lightYellow
        self.navigationBar.barTintColor = SceneColor.black
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : SceneColor.yellow]
        //TODO:remove 1px border
        
        //初始化蒙板
        maskView = UIView(frame: view.bounds)
        maskView.alpha = 0.3
        maskView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(maskView)

        //初始化手势
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
        self.maskView.addGestureRecognizer(tapGestureRecognizer)
        
        if let pan = panGestureRecognizer {
            self.maskView.addGestureRecognizer(pan)
        }
        
        refreshMask()
    }
    
    //更新蒙板状态
    func refreshMask() {
        let masked = slideDelegate?.isOpening() ?? false
        self.maskView.hidden = !masked
    }

    //MASK: Gestures
    
    func tapGestureHandler(sender: UITapGestureRecognizer){
        if sender.state == .Ended {
            slideDelegate?.dismissMenu()
        }
    }
    
    //MASK: Unwind Segues
    
    @IBAction func backingPrepareForSegue(segue: UIStoryboardSegue){
        //self.slideMenuState = SlideMenuState.Closing
        println("backingPrepareForSegue")
        dismissViewControllerAnimated(true, completion: nil)
    }

}
