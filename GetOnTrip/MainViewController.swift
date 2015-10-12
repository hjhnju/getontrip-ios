
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
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.hidesBackButton = true
        
        let fixspaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixspaceItem.width = -8
        navigationItem.leftBarButtonItems = [fixspaceItem, UIBarButtonItem(customView: leftView)]
        
        let rightFixspaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        rightFixspaceItem.width = -8
        navigationItem.rightBarButtonItems = [rightFixspaceItem, UIBarButtonItem(customView: rightView)]
        
        refreshBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        leftView.frame  = CGRectMake(0, 0, 21, 14)
        rightView.frame = CGRectMake(0, 0, view.bounds.width-(414-356), 35)
        
        slideButton.frame  = leftView.bounds
        searchButton.frame = rightView.bounds
    }
    
    func refreshBar() {
        //navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        navigationController?.navigationBar.tintColor    = UIColor.whiteColor()
        //navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : SceneColor.white]
        //navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: 自定义方法
    
    func toggleMenu(){
        slideDelegate?.toggle()
    }
    
    func showSearch(){
        print("showing Searching")
    }
}
