//
//  FavoriteViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/1.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class FavoriteViewController: UIViewController, UIScrollViewDelegate {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    // MARK: - 属性
    lazy var scrollView: UIScrollView = UIScrollView()
    
    /// 底图背景颜色
    lazy var containView: UIView = UIView()
    
    /// 按钮背景的view
    lazy var btnBackground: UIView = UIView()
    
    /// 左边线
    lazy var line1: UIView = UIView()
    
    /// 右边线
    lazy var line2: UIView = UIView()
    
    // 景点底图
    lazy var view1: UIView = UIView(frame: UIScreen.mainScreen().bounds)

    /// 话题底图
    lazy var view2: UIView = UIView(frame: UIScreen.mainScreen().bounds)
    
    /// 主题底图
    lazy var view3: UIView = UIView(frame: UIScreen.mainScreen().bounds)
    
    /// 景点按钮
    lazy var sightBtn: CollectButton = CollectButton(title: "景点", imageName: "sight_image", fontSize: 14, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.3))
    /// 话题按钮
    lazy var topicBtn: CollectButton = CollectButton(title: "话题", imageName: "topic_image", fontSize: 14, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.3))
    /// 主题按钮
    lazy var motifBtn: CollectButton = CollectButton(title: "主题", imageName: "motif_image", fontSize: 14, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.3))
    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddSubViewAndAction()
        setupAutoLayout()
//        setupDefaultSightTopic()
        setupChildControllerProperty()
        
    }
    
    private func setupProperty() {
        
        title = "我的收藏"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);
        containView.backgroundColor = UIColor(patternImage: UIImage(named: "collect_background")!)
        recordButtonStatus = sightBtn
    }
    
    private func setupAddSubViewAndAction() {
        
        view.addSubview(containView)
        containView.addSubview(scrollView)
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        scrollView.addSubview(view3)
        view.addSubview(btnBackground)
        btnBackground.addSubview(sightBtn)
        btnBackground.addSubview(topicBtn)
        btnBackground.addSubview(motifBtn)
        btnBackground.addSubview(line1)
        btnBackground.addSubview(line2)

        sightBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        topicBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        motifBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    // MARK: - 初始化自动布局
    private func setupAutoLayout() {
        
        let btnW: CGFloat = view.bounds.width / 3
        let btnH: CGFloat = 70
        btnBackground.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, btnH), offset: CGPointMake(0, 64))
        sightBtn.ff_AlignInner(ff_AlignType.TopLeft, referView: btnBackground, size: CGSizeMake(btnW, btnH), offset: CGPointMake(0, 0))
        line1.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: sightBtn, size: CGSizeMake(0.5, 50), offset: CGPointMake(0, 0))
        topicBtn.ff_AlignInner(ff_AlignType.CenterCenter, referView: btnBackground, size: CGSizeMake(btnW, btnH), offset: CGPointMake(0, 0))
        line2.ff_AlignHorizontal(ff_AlignType.CenterCenter, referView: topicBtn, size: CGSizeMake(0.5, 50), offset: CGPointMake(0, 0))
        motifBtn.ff_AlignInner(ff_AlignType.TopRight, referView: btnBackground, size: CGSizeMake(btnW, btnH), offset: CGPointMake(0, 0))
        containView.ff_AlignInner(ff_AlignType.BottomCenter, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 64 - btnH), offset: CGPointMake(0, 0))
        scrollView.ff_AlignInner(ff_AlignType.CenterCenter, referView: containView, size: nil, offset: CGPointMake(0, 0))
    }
    
    /// MARK: - 切换收藏视图方法
    /// 记录按钮的状态
    var recordButtonStatus: UIButton?
    func switchCollectButtonClick(sender: UIButton) {
        recordButtonStatus?.selected = false
        sender.selected = true
        recordButtonStatus = sender
        
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

