//
//  FavoriteViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/1.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class FavoriteViewController: MenuViewController, UIScrollViewDelegate {
    
    static let name = "我的收藏"
    
    // MARK: - 属性
    lazy var titleBackground: UIView = UIView()
    
    /// 内容底部scrollview
    lazy var contentScrollView: CollectScrollerview = CollectScrollerview()
    
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

        view.backgroundColor = SceneColor.bgBlack
        titleBackground.backgroundColor = SceneColor.bgBlack
        contentScrollView.backgroundColor = UIColor.whiteColor()
        
        navBar.setTitle(FavoriteViewController.name)
        
        setupAddSubViewAndAction()
        setupAutoLayout()
        setupChildControllerProperty()
        let vc = parentViewController?.parentViewController as? SlideMenuViewController
        
        vc?.view.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit {
        let vc = parentViewController?.parentViewController as? SlideMenuViewController
        vc?.view.removeObserver(self, forKeyPath: "frame", context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print(change)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    private func setupAddSubViewAndAction() {
    
        view.addSubview(titleBackground)
        view.addSubview(contentScrollView)
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
        sightBtn.ff_AlignInner(ff_AlignType.CenterCenter, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        contentBtn.ff_AlignInner(ff_AlignType.CenterLeft, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        cityBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        selectView.frame = CGRectMake(11, 34, 73, 1.5)
        
        let wBounds = UIScreen.mainScreen().bounds.width
        let hBounds = UIScreen.mainScreen().bounds.height - 64 - 32
        contentScrollView.frame = CGRectMake(0, 64 + 36, wBounds, hBounds)
        contentScrollView.contentSize = CGSize(width: wBounds * 3, height: hBounds)
        contentScrollView.contentOffset = CGPointMake(0, 0)
        contentController.view.frame = CGRectMake(0, 0, wBounds, hBounds)
        sightViewController.view.frame = CGRectMake(wBounds, 0, wBounds, hBounds)
        cityController.view.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
    }
    
    
    /// MARK: - 切换收藏视图方法
    var selectedIndex: Int?
    func switchCollectButtonClick(sender: UIButton) {
        
        UIView.animateWithDuration(0.5) { [unowned self] () -> Void in
            self.selectView.center.x = sender.center.x
        }

        if sender == contentBtn { selectedIndex = 0 }
        else if sender == sightBtn { selectedIndex = 1 }
        else if sender == cityBtn { selectedIndex = 2 }
        UIView.animateWithDuration(0.5) { [unowned self] () -> Void in
            self.contentScrollView.contentOffset.x = self.contentScrollView.bounds.width * CGFloat(self.selectedIndex!)
        }
    }
    
    
    func setupChildControllerProperty() {
        contentScrollView.pagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        contentScrollView.bounces = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let x1: CGFloat = scrollView.contentOffset.x / CGFloat(3) + selectView.bounds.width * 0.5
        print(scrollView.contentOffset.x)
        
        let current = CGFloat(scrollView.contentOffset.x / scrollView.bounds.size.width)

        selectView.center.x = scrollView.contentOffset.x / CGFloat(3) + selectView.bounds.width * 0.5 + 11 + current * (11 / 3)
    }
    

    
}

class CollectScrollerview: UIScrollView {
    
    /// true 为事件查找到自己，false为事件查找到父类
//    var isHitTest: Bool = true
//    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//        if (isHitTest == true) {
//            return self
//        }
//        return superview
//    }
    
}

