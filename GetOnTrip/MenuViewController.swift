//
//  ContainerViewController.swift
//  Project-Menu
//
//  Created by guojinli on 15/7/17.
//  Copyright (c) 2015年 guojinli. All rights reserved.
//
import UIKit
//定义侧边栏距离左边的距离，浮点型
let  kICSDrawerControllerDrawerDepth : CGFloat = 200.0

let kICSDrawerControllerLeftViewInitialOffset : CGFloat  = 60.0

//定义侧边栏的两种状态（打开，关闭）枚举类型
enum ICSDrawerControllerState : Int {
    case MenuControllerStateOpening
    case MenuControllerStateClosing
}

class MenuViewController: UIViewController {
    //定义窗体主体Controller
    var mainViewController = UINavigationController()
    
    //定义侧边栏的Controller
    var sideViewController = SideViewController()
    
    //定义当前侧边栏的状态
    var drawerState : ICSDrawerControllerState!
    
    //用户拖动视图
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    //用户touch的点位置
    var panGestureStartLocation : CGPoint!
    
    //用户点击center
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化侧边栏和主体控制器
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var storyboardMain = storyboard.instantiateViewControllerWithIdentifier("MainID") as! MainViewController
        self.sideViewController = storyboard.instantiateViewControllerWithIdentifier("SlideBarID") as! SideViewController
        //添加导航栏按钮
        
        //初始化导航栏
        var navigation = UINavigationController(rootViewController:storyboardMain)
        navigation.navigationBar.barTintColor = UIColor.blackColor()
        storyboardMain.navigationItem.leftBarButtonItem = NavigationItemView.CreateLeftItem(self)
        storyboardMain.navigationItem.rightBarButtonItem = NavigationItemView.CreateRightItem(self)
        self.mainViewController = navigation
        
        
        //初始状态时是关闭状态
        self.drawerState = ICSDrawerControllerState.MenuControllerStateClosing
        //添加用户拖动事件
        self.panGestureRecognizer = UIPanGestureRecognizer()
        self.panGestureRecognizer.addTarget(self,action:"panGestureRecognized:")
        self.view.addGestureRecognizer(self.panGestureRecognizer)
        
        
    }
    //状态栏变为白色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    //实现窗体出现时的函数
    override func viewDidAppear(animated: Bool){
        //为入口添加Controller，前提是该controller的view没有父元素
        if (self.sideViewController.view.superview == nil){
            self.addChildViewController(sideViewController)
            self.view.insertSubview(sideViewController.view, atIndex: 0)
        }
        
        if (self.mainViewController.view.superview == nil){
            self.addChildViewController(mainViewController)
            self.view.addSubview(mainViewController.view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //用户拖动视图调用代理方法。
    func panGestureRecognized(panGestureRecognizer:UIPanGestureRecognizer){
        //用户对视图操控的状态。
        var state = panGestureRecognizer.state;
        
        var location = panGestureRecognizer.locationInView(self.mainViewController.view)
        
        var velocity = panGestureRecognizer.velocityInView(self.mainViewController.view)
        
        switch (state) {
        case UIGestureRecognizerState.Began:
            //记录用户开始点击的位置
            self.panGestureStartLocation = location;
            break;
        case UIGestureRecognizerState.Changed:
            var c = self.mainViewController.view.frame
            if (panGestureRecognizer.translationInView(self.mainViewController.view).x > 0){
                if (self.drawerState == ICSDrawerControllerState.MenuControllerStateClosing){
                    c.origin.x = location.x - self.panGestureStartLocation.x;
                }
            }else if (panGestureRecognizer.translationInView(self.view).x > -kICSDrawerControllerDrawerDepth){
                if (self.drawerState == ICSDrawerControllerState.MenuControllerStateOpening){
                    c.origin.x = panGestureRecognizer.translationInView(self.mainViewController.view).x+kICSDrawerControllerDrawerDepth
                }
            }
            self.mainViewController.view.frame = c ;
            break;
        case UIGestureRecognizerState.Ended:
            var c = self.mainViewController.view.frame
            //表示用户需要展开
            if (location.x - self.panGestureStartLocation.x > kICSDrawerControllerLeftViewInitialOffset){
                self.didOpen()
            }else {
                if  (c.origin.x < (kICSDrawerControllerDrawerDepth - 40)){
                    self.didClose()
                }else {
                    self.didOpen()
                }
            }
            break;
        default:
            break;
        }
    }
    //打开侧边栏
    func didOpen(){
        //首先得到主窗体的尺寸
        var mainSize = self.mainViewController.view.frame
        //设置主窗体的起始位置，加上制定的数值
        mainSize.origin.x = kICSDrawerControllerDrawerDepth
        UIView.animateWithDuration(0.7,delay:0,usingSpringWithDamping:1,initialSpringVelocity:1.0,options:UIViewAnimationOptions.AllowUserInteraction,animations:{
            self.mainViewController.view.frame = mainSize;
            },completion: { (finished: Bool) -> Void in
        })
        //将侧边栏的装填标记为打开状态
        self.drawerState = ICSDrawerControllerState.MenuControllerStateOpening
        //增加点击事件,当菜单打开以后需要为其绑定，点击窗体任何地方都要消失测边栏
        if (self.tapGestureRecognizer == nil){
            self.tapGestureRecognizer  = UITapGestureRecognizer()
            self.tapGestureRecognizer.addTarget(self,action:"tapGestureRecognized:");
        }
        //self.mainViewController.view.addGestureRecognizer(self.tapGestureRecognizer)
    }
    //关闭侧边栏
    func didClose(){
        //点击关闭时要将当前状态标记为关闭
        if drawerState == ICSDrawerControllerState.MenuControllerStateOpening {
            drawerState = ICSDrawerControllerState.MenuControllerStateClosing
        }
        //将主窗体的起始位置恢复到原始状态
        var mainSize = self.mainViewController.view.frame
        mainSize.origin.x = 0
        UIView.animateWithDuration(0.7,delay:0,usingSpringWithDamping:1,initialSpringVelocity:1.0,options:UIViewAnimationOptions.AllowUserInteraction,animations:{
            self.mainViewController.view.frame = mainSize;
            },completion: { (finished: Bool) -> Void in
        })
    }
    //点击主窗体时出发的函数
    func tapGestureRecognized(tapGestureRecognizer : UITapGestureRecognizer){
        self.didClose()
    }
    
    func tappedButtonSlide(button : UIButton){
        if (self.drawerState == ICSDrawerControllerState.MenuControllerStateOpening){
            self.didClose()
        }else{
            self.didOpen()
        }
    }
    
    func tappedButtonSearch(button : UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var searchController = storyboard.instantiateViewControllerWithIdentifier("SearchID") as! SearchViewController
        self.presentViewController(searchController, animated: false, completion: nil)
    }
}
