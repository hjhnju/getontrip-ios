//
//  SlideMenuViewController.swift
//  GetOnTrip
//  滑动菜单的控制器
//
//  Created by 何俊华 on 15/7/30.
//  Copyright (c) 2015年 Joshua. All rights reserved.

import UIKit

//定义侧边栏的两种状态（打开，关闭）枚举类型
enum SlideMenuState: Int {
    case Opening = 1
    case Closing
    mutating func toggle() {
        switch self {
        case .Closing:
            self = .Opening
        case .Opening:
            self = .Closing
        }
    }
}

protocol SlideMenuViewControllerDelegate {
    
    func displayMenu() -> Void
    
    func dismissMenu() -> Void
    
    //SlideMenu是否打开状态
    func isOpening() -> Bool
}

struct SlideMenuOptions {
    //拉伸的宽度
    static let DrawerWidth: CGFloat = UIScreen.mainScreen().bounds.width * 0.75
    //高度
    static let DrawerHeight: CGFloat = UIScreen.mainScreen().bounds.height
    //定义侧边栏距离左边的距离，浮点型
    static var kICSDrawerControllerLeftViewInitialOffset : CGFloat  = 60.0
}

class SlideMenuViewController: UIViewController, SlideMenuViewControllerDelegate {
    
    //MASK: Properties
    
    //定义窗体主体Controller
    var masterViewController: MasterViewController!
    
    //定义侧边栏的Controller
    var sideViewController: MenuViewController!
    
    //定义当前侧边栏的状态
    var slideMenuState: SlideMenuState = SlideMenuState.Closing
    
    //用户拖动视图
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    //用户touch的点位置
    var panGestureStartLocation : CGPoint!
    
    //MASK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化侧边栏和主体控制器
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //TODO:处理登陆状态
        //self.sideViewController = storyboard.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.MenuViewId) as! MenuViewController
        self.sideViewController = storyboard.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.MenuViewID) as! MenuViewController
        
        self.masterViewController = storyboard.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.MainNavViewID) as! MasterViewController
        
        self.masterViewController.slideDelegate = self
        
        //添加用户拖动事件
        self.panGestureRecognizer = UIPanGestureRecognizer()
        self.panGestureRecognizer.addTarget(self, action:"panGestureRecognized:")
        self.sideViewController.view.addGestureRecognizer(self.panGestureRecognizer)
        self.masterViewController.panGestureRecognizer = self.panGestureRecognizer
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if (self.slideMenuState == SlideMenuState.Opening) {
            self.didOpen()
        } else {
            self.didClose()
        }
    }
    
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
        //限制宽度
        self.sideViewController.view.frame = CGRect(x: 0, y: 0, width: SlideMenuOptions.DrawerWidth, height: SlideMenuOptions.DrawerHeight)
        
        if (self.masterViewController.view.superview == nil){
            self.addChildViewController(masterViewController)
            self.view.addSubview(masterViewController.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MASK: Gestures
    
    //用户拖动视图调用代理方法。
    func panGestureRecognized(sender: UIPanGestureRecognizer){
        
        //用户对视图操控的状态。
        var state = sender.state;
        var location = sender.locationInView(self.masterViewController.view)
        var velocity = sender.velocityInView(self.masterViewController.view)
        
        switch (state) {
        case UIGestureRecognizerState.Began:
            //记录用户开始点击的位置
            self.panGestureStartLocation = location;
            break;
        case UIGestureRecognizerState.Changed:
            var c = self.masterViewController.view.frame
            if (sender.translationInView(self.masterViewController.view).x > 0){
                if (self.slideMenuState == SlideMenuState.Closing){
                    c.origin.x = location.x - self.panGestureStartLocation.x;
                }
            } else if (sender.translationInView(self.view).x > -SlideMenuOptions.DrawerWidth){
                if (self.slideMenuState == SlideMenuState.Opening){
                    c.origin.x = panGestureRecognizer.translationInView(self.masterViewController.view).x + SlideMenuOptions.DrawerWidth
                }
            }
            self.masterViewController.view.frame = c ;
            break;
        case UIGestureRecognizerState.Ended:
            var c = self.masterViewController.view.frame
            //表示用户需要展开
            if (location.x - self.panGestureStartLocation.x > SlideMenuOptions.kICSDrawerControllerLeftViewInitialOffset){
                self.didOpen()
            }else {
                if  (c.origin.x < (SlideMenuOptions.DrawerWidth - 40)){
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
        
        //设置主窗体的结束位置
        var mainSize = self.masterViewController.view.frame
        mainSize.origin.x = SlideMenuOptions.DrawerWidth
        //动效
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations:{ self.masterViewController.view.frame = mainSize;
                let tc = self.sideViewController.childViewControllers[0] as!MenuTableViewController
                self.sideViewController.logined = sharedUserAccount != nil ? true : false
                self.sideViewController.refresh()
                tc.tableView.hidden = false
                tc.cellx = 0
                tc.tableView.reloadData()
            },
            completion: { (finished: Bool) -> Void in
            }
        )
        
        
        
        //将侧边栏的装填标记为打开状态
        self.slideMenuState = SlideMenuState.Opening
        
        self.masterViewController.refreshMask()
    }
    
    //关闭侧边栏
    func didClose(){
        //点击关闭时要将当前状态标记为关闭
        if slideMenuState == SlideMenuState.Opening {
            slideMenuState = SlideMenuState.Closing
        }
        //将主窗体的起始位置恢复到原始状态
        var mainSize = self.masterViewController.view.frame
        mainSize.origin.x = 0
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { self.masterViewController.view.frame = mainSize; },
            completion: { (finished: Bool) -> Void in
            let tc = self.sideViewController.childViewControllers[0] as!MenuTableViewController
                tc.tableView.hidden = true
            }
        )
        
        self.masterViewController.refreshMask()
    }
 
    //Mask: MainViewControllerDelegate
    
    func isOpening() -> Bool {
        return slideMenuState == SlideMenuState.Opening ? true : false
    }
    
    func displayMenu() -> Void {
        self.didOpen()
    }
    
    func dismissMenu() -> Void {
        self.didClose()
    }

}
