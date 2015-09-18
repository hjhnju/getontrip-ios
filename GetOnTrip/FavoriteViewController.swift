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
    /// 按钮背景的view
    @IBOutlet weak var btnBackground: UIView!
    /// 左边线
    @IBOutlet weak var line1: UIView!
    /// 右边线
    @IBOutlet weak var line2: UIView!
    
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
        recordButtonStatus = sightBtn

//        setupDefaultSightTopic()
        setupChildControllerProperty()
        
        sightBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        topicBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        motifBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /// MARK: - 切换收藏视图方法
    /// 记录按钮的状态
    var recordButtonStatus: UIButton?
    func switchCollectButtonClick(sender: UIButton) {
        recordButtonStatus?.selected = false
        sender.selected = true
        recordButtonStatus = sender
        
        //        compositorItem.customView?.hidden = true
        
        //        if sender.currentTitle == "话题" {
        //            compositorItem.customView?.hidden = false
        //        }
        
        if !sender.selected {
            sender.selected = true
            recordButtonStatus = sender
        }

        var selectedIndex: CGFloat = 0
        if sender == sightBtn { selectedIndex = 0 }
        else if sender == topicBtn { selectedIndex = 1 }
        else if sender == motifBtn { selectedIndex = 2 }
        scrollView.contentOffset.x = containView.bounds.width * selectedIndex
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        line1.bounds = CGRectMake(0, 0, 0.5, 1)
        line2.bounds = CGRectMake(0, 0, 0.5, 1)
    }
    
    // 搜索
    func searchButtonClicked(button: UIBarButtonItem) {
        // 获得父控制器
        let pare = self.parentViewController?.parentViewController as! MasterViewController
        // 找到MainViewController并调用搜索方法
        for vc in pare.viewControllers {
            if vc.isKindOfClass(MainViewController) {
                let vc1 = vc as! MainViewController
                vc1.searchButtonClicked(button)
            }
        }
    }
    
    func setupChildControllerProperty() {
        
        scrollView.contentOffset.x = 0
        
        
        //初始化scrollview
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        
        //初始化views
        addChildViewController(sightViewController)
        view1.addSubview(sightViewController.view)
        scrollView.addSubview(view1)
        
        
        addChildViewController(collectTopicController)
        view2.addSubview(collectTopicController.view)
        scrollView.addSubview(view2)
        
        addChildViewController(motifController)
        view3.addSubview(motifController.view)
        scrollView.addSubview(view3)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //初始化scrollView, subview's bounds确定后
        let wBounds = containView.bounds.width
        let hBounds = containView.bounds.height
        
        scrollView.contentSize = CGSize(width: wBounds * 3, height: hBounds * 0.5)
        
        view1.frame = CGRectMake(0, 0, wBounds, hBounds)
        view2.frame = CGRectMake(wBounds, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(collectTopicController.view)
        view3.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(motifController.view)
    }
    
    
    //MASK: Actions
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        let xOffset: CGFloat = scrollView.contentOffset.x
        if (xOffset < 1.0) {
            switchCollectButtonClick(sightBtn)
        } else if (xOffset < containView.bounds.width + 1) {
            switchCollectButtonClick(topicBtn)
        } else {
            switchCollectButtonClick(motifBtn)
        }
    }
    
    // MARK: 懒加载
    // 景点控制器
    lazy var sightViewController: CollectSightViewController = {
        return CollectSightViewController()
    }()
    
    // 话题控制器
    lazy var collectTopicController: CollectTopicViewController = {
        let story1 = UIStoryboard(name: "Main", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.CollectTopicSB) as! CollectTopicViewController
    }()
    
    // 主题控制器
    lazy var motifController: CollectMotifViewController = {
        let story1 = UIStoryboard(name: "Main", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.CollectMotifSB) as! CollectMotifViewController
    }()
    
}



