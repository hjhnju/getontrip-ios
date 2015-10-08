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
    lazy var titleBackground: UIView = UIView(color: SceneColor.lightBlack, alphaF: 1.0)
    
    /// 内容底部scrollview
    lazy var contentScrollView: UIScrollView = UIScrollView()
    
    /// 景点按钮
    lazy var sightBtn: UIButton = UIButton(title: "景点", fontSize: 14, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 话题按钮
    lazy var contentBtn: UIButton = UIButton(title: "内容", fontSize: 14, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 城市按钮
    lazy var cityBtn: UIButton = UIButton(title: "城市", fontSize: 14, radius: 0, titleColor: UIColor.whiteColor())
    
    lazy var selectView: UIView = UIView(color: UIColor.yellowColor(), alphaF: 1.0)
    
    // 景点控制器
    lazy var sightViewController: CollectSightViewController = CollectSightViewController()
    
    // 内容控制器
    lazy var contentController: CollectContentViewController = CollectContentViewController()
    
    // 城市控制器
    lazy var cityController: CollectCityViewController = CollectCityViewController()

    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperty()
        setupAddSubViewAndAction()
        setupAutoLayout()
//        setupDefaultSightTopic()
        setupChildControllerProperty()
        
    }
    
    private func setupProperty() {
        
        title = "我的收藏"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        view.backgroundColor = UIColor.whiteColor()
//        recordButtonStatus = sightBtn
    }
    
    private func setupAddSubViewAndAction() {
        
        view.addSubview(titleBackground)
        view.addSubview(contentScrollView)
        contentScrollView.backgroundColor = UIColor.blueColor()
        titleBackground.addSubview(cityBtn)
        titleBackground.addSubview(sightBtn)
        titleBackground.addSubview(contentBtn)
        contentScrollView.addSubview(cityController.view)
        contentScrollView.addSubview(contentController.view)
        contentScrollView.addSubview(sightViewController.view)
        titleBackground.addSubview(selectView)
        
        addChildViewController(cityController)
        addChildViewController(contentController)
        addChildViewController(sightViewController)
        
        cityBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        sightBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        contentBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    // MARK: - 初始化自动布局
    private func setupAutoLayout() {
        
        automaticallyAdjustsScrollViewInsets = false
        titleBackground.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 36), offset: CGPointMake(0, 64))
        contentScrollView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleBackground, size: CGSizeMake(view.bounds.width, view.bounds.height), offset: CGPointMake(0, 0))
        contentBtn.ff_AlignInner(ff_AlignType.CenterCenter, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        sightBtn.ff_AlignInner(ff_AlignType.CenterLeft, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        cityBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
    }
    
    
    /// MARK: - 切换收藏视图方法
    /// 记录按钮的状态
    var recordButtonStatus: UIButton?
    func switchCollectButtonClick(sender: UIButton) {
        recordButtonStatus?.selected = false
        sender.selected = true
        recordButtonStatus = sender
        
        UIView.animateWithDuration(0.5) { [unowned self] () -> Void in
            self.selectView.center.x = sender.center.x
        }
        
        if !sender.selected {
            sender.selected = true
            recordButtonStatus = sender
        }

        var selectedIndex: CGFloat = 0
        if sender == sightBtn { selectedIndex = 0 }
        else if sender == contentBtn { selectedIndex = 1 }
        else if sender == cityBtn { selectedIndex = 2 }
//        contentScrollView.contentOffset.x = containView.bounds.width * selectedIndex
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        selectView.frame = CGRectMake(27 * 0.5, 34.5, 73, 1.5)
//        selectView.center.x = sightBtn.center.x
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    // 搜索
    func searchButtonClicked(button: UIBarButtonItem) {
        // 获得父控制器
//        let pare = self.parentViewController?.parentViewController as! MasterViewController
//        // 找到MainViewController并调用搜索方法
//        for vc in pare.viewControllers {
//            if vc.isKindOfClass(MainViewController) {
//                let vc1 = vc as! MainViewController
//                vc1.searchButtonClicked(button)
//            }
//        }
    }
    
    func setupChildControllerProperty() {
        
        contentScrollView.contentOffset.x = 0
        
        //初始化scrollview
        contentScrollView.pagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        contentScrollView.bounces = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //初始化scrollView, subview's bounds确定后
        let wBounds = contentScrollView.bounds.width
        let hBounds = contentScrollView.bounds.height
        
        contentScrollView.contentSize = CGSize(width: wBounds * 3, height: hBounds * 0.5)
        
        sightViewController.view.frame = CGRectMake(0, 0, wBounds, hBounds)
        contentController.view.frame = CGRectMake(wBounds, 0, wBounds, hBounds)
//        contentScrollView.bringSubviewToFront(collectTopicController.view)
        cityController.view.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
//        scrollView.bringSubviewToFront(motifController.view)
        
        
    }
    
    
    //MASK: Actions
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        let xOffset: CGFloat = scrollView.contentOffset.x
        if (xOffset < 1.0) {
            switchCollectButtonClick(sightBtn)
        } else if (xOffset < titleBackground.bounds.width + 1) {
            switchCollectButtonClick(contentBtn)
        } else {
            switchCollectButtonClick(cityBtn)
        }
    }
    
}

