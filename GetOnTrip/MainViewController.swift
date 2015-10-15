
//
//  BaseHomeController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class MainViewController: UIViewController {
    
    // MASK: Properties
    
    //代理左侧菜单的操作
    var slideDelegate: SlideMenuViewControllerDelegate?
    
    lazy var leftView: UIView = {
        let view = UIView()
        view.addSubview(self.slideButton)
        view.backgroundColor = UIColor.clearColor()
        return view
        }()
    
    lazy var rightView: UIView = {
        let view = UIView()
        view.addSubview(self.searchButton)
        view.backgroundColor = UIColor.clearColor()
        return view
        }()
    
    lazy var slideButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setBackgroundImage(UIImage(named: "icon_hamburger"), forState: UIControlState.Normal)
        button.addTarget(self, action: "toggleMenu", forControlEvents: UIControlEvents.TouchUpInside)
        return button
        }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setBackgroundImage(UIImage(named: "icon_search"), forState: UIControlState.Normal)
        button.addTarget(self, action: "showSearch", forControlEvents: UIControlEvents.TouchUpInside)
        return button
        }()
    
    // MASK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //导航Items
        let leftFixspaceItem    = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        let rightFixspaceItem   = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        leftFixspaceItem.width  = -10
        rightFixspaceItem.width = -10
        navigationItem.leftBarButtonItems  = [leftFixspaceItem, UIBarButtonItem(customView: leftView)]
        navigationItem.rightBarButtonItems = [rightFixspaceItem, UIBarButtonItem(customView: rightView)]
        navigationItem.backBarButtonItem   = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        leftView.frame  = CGRectMake(0, 0, 21, 14)
        rightView.frame = CGRectMake(0, 0, view.bounds.width-(414-356), 35)
        slideButton.frame  = leftView.bounds
        searchButton.frame = rightView.bounds
        
        //初始化导航背景
//        let statusBarHeight:CGFloat = 20
//        let barFrame = CGRectMake(0, -statusBarHeight, navigationController!.navigationBar.frame.width, navigationController!.navigationBar.frame.height + statusBarHeight)
//        navUnderlayView.frame = barFrame
//        navUnderlayView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        navUnderlayView.alpha = 0.0
//        navigationController?.navigationBar.insertSubview(navUnderlayView, atIndex: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: 自定义方法
    
    func toggleMenu(){
        slideDelegate?.toggle()
    }
    
    func showSearch(){
        print("showing Searching")
    }
    

}
