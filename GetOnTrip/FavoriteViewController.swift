//
//  FavoriteViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/1.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UIScrollViewDelegate {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containView: UIView!
    
    @IBOutlet weak var background: UIView!
    // 景点底图
    lazy var view1: UIView = {
        var tempView = UIView(frame: UIScreen.mainScreen().bounds)
        return tempView
    }()
    
    // 话题底图
    lazy var view2: UIView = {
        var tempView = UIView(frame: UIScreen.mainScreen().bounds)
        return tempView
    }()
    
    // 主题底图
    lazy var view3: UIView = {
        var tempView = UIView(frame: UIScreen.mainScreen().bounds)
        return tempView
    }()
    
    /// 景点按钮
    @IBOutlet weak var sightBtn: UIButton!
    /// 话题按钮
    @IBOutlet weak var topicBtn: UIButton!
    /// 主题按钮
    @IBOutlet weak var motifBtn: UIButton!
    
    // MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);
        containView.backgroundColor = UIColor(patternImage: UIImage(named: "collect_background")!)
        
        
//        self.navigationController?.navigationBar.barTintColor = SceneColor.crystalWhite
//        self.navigationController?.navigationBar.tintColor = SceneColor.lightGray
        
//        setupDefaultSightTopic()
        setupChildControllerProperty()
        
    }
    
    func navigationChangeTitle() {
        navigationItem.hidesBackButton = false
    }
    
    // 搜索
    func searchButtonClicked(button: UIBarButtonItem) {
        // 获得父控制器
        var pare = self.parentViewController?.parentViewController as! MasterViewController
        // 找到MainViewController并调用搜索方法
        for vc in pare.viewControllers {
            if vc.isKindOfClass(MainViewController) {
                vc.searchButtonClicked(button)
            }
        }
    }
    
    func setupChildControllerProperty() {
        
        scrollView.contentOffset.x = UIScreen.mainScreen().bounds.width
        
        
        //初始化scrollview
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        
        //初始化views
        addChildViewController(sightViewController)
        view1.addSubview(sightViewController.view)
        sightViewController.view.backgroundColor = UIColor.orangeColor()
        scrollView.addSubview(view1)
        
        
        addChildViewController(collectTopicController)
        view2.addSubview(collectTopicController.view)
        scrollView.addSubview(view2)
        
        addChildViewController(motifController)
        view3.addSubview(motifController.view)
        motifController.view.backgroundColor = UIColor.blueColor()
        scrollView.addSubview(view3)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //初始化scrollView, subview's bounds确定后
        let wBounds = containView.bounds.width
        let hBounds = containView.bounds.height
        
        scrollView.contentSize = CGSize(width: wBounds * 4, height: hBounds/2)
        
        view1.frame = CGRectMake(0, 0, wBounds, hBounds)
        
        view2.frame = CGRectMake(wBounds, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(collectTopicController.view)
        
        view3.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(motifController.view)
    }
    
    
    //MASK: Actions
    var recordButtonStatus: UIButton?
    
    
    @IBAction func selectItem(sender: UIButton) {
        
        recordButtonStatus?.backgroundColor = UIColor.clearColor()
        recordButtonStatus?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        recordButtonStatus?.selected = false
        
//        compositorItem.customView?.hidden = true
        
//        if sender.currentTitle == "话题" {
//            compositorItem.customView?.hidden = false
//        }
        
        if !sender.selected {
            sender.selected = true
            sender.backgroundColor = UIColor(white: 1, alpha: 0.5)
            sender.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            sender.layer.masksToBounds = true
            sender.layer.cornerRadius = 15
            recordButtonStatus = sender
        }
        
        //set select
//        selectedItem = sender
        //move
//        var selectedIndex: CGFloat = 0
//        if selectedItem == item1 { selectedIndex = 0 }
//        else if selectedItem == item2 { selectedIndex = 1 }
//        else if selectedItem == item3 { selectedIndex = 2 }
//        else if selectedItem == item4 { selectedIndex = 3 }
//        scrollView.contentOffset.x = containView.bounds.width * selectedIndex
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var xOffset: CGFloat = scrollView.contentOffset.x
        if (xOffset < 1.0) {
//            selectedItem = item1
//            compositorItem.customView?.hidden = true
//            selectItem(item1)
//        } else if (xOffset < containView.bounds.width + 1) {
//            selectedItem = item2
//            compositorItem.customView?.hidden = false
//            selectItem(item2)
//        } else {
//            selectedItem = item4
//            compositorItem.customView?.hidden = true
//            selectItem(item4)
        }
    }
    
    // MARK: 懒加载
    // 景点控制器
    lazy var sightViewController: CollectSightViewController = {
//        let story1 = UIStoryboard(name: "Main", bundle: nil)
//        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicCyclopaedicSB) as! CyclopaedicViewController
        return CollectSightViewController()
    }()
    
    // 话题控制器
    lazy var collectTopicController: CollectTopicViewController = {
        let story1 = UIStoryboard(name: "Main", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.CollectTopicSB) as! CollectTopicViewController
    }()
    
    // 主题控制器
    lazy var motifController: UIViewController = {
//        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
//        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicBookSB) as! BookController
        return UIViewController()
    }()
    
}
