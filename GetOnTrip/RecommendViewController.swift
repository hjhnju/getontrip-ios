//
//  SearchListPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import ReachabilitySwift

struct MainViewContant {
    //状态栏高度
    static let StatusBarHeight:CGFloat = 20
    //初始化导航栏高度
    static let MaxNavbarHeight:CGFloat = 70
    //导航栏最小高度
    static let MinNavbarHeight:CGFloat = 44
    //搜索栏高度
    static let SearchBarHeight:CGFloat = 34
}

struct RecommendContant {
    static let headerViewHeight:CGFloat = Device.isIPad() ? Frame.screen.height * 0.229619565 + 45 * 2 : 255
    static let rowHeight:CGFloat = Device.isIPad() ? Frame.screen.height * 0.260869 : 199
    static let searchBarTopY: CGFloat = RecommendContant.headerViewHeight - 45 - 20 - 35 // Frame.screen.height * 0.21195652
}

class RecommendViewController: MainViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    // 单例
    static let sharedRecommendViewController = RecommendViewController()
    
    /// 记录滚动位置
    var searchBarTX: CGFloat = 0
    var searchBarTY: CGFloat = 0
    var searchBarTW: CGFloat = 0
    var searchBarTH: CGFloat = 0
    var searchBarFW: CGFloat = 0
    
    /// 搜索框约束
    var searchBarW   : NSLayoutConstraint?
    var searchBarH   : NSLayoutConstraint?
    var searchBarMaxX: NSLayoutConstraint?
    var searchBarTopY: NSLayoutConstraint?
    /// headerView的顶部约束
    var headerViewTopConstraint: NSLayoutConstraint?
    
    //导航高度
    var navBarHeight:CGFloat = 0.0
    
    //导航透明度
    var navBarAlpha:CGFloat = 0.0 {
        didSet{
            refreshBar()
        }
    }
    
    // MARK: - 控件
    /// 底部容器view
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    /// 左侧滑动view
    lazy var slideView: UIView = UIView()
    /// 流水布局
    lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    /// 导航栏容器，包含状态栏的高度
    lazy var navContainerView:UIView = UIView()
    /// 侧滑导航按钮
    let slideNavButton: RecommendSlideButton = RecommendSlideButton(image: "icon_hamburger", title: "", fontSize: 0, titleColor: SceneColor.lightYellow)
    //自定义导航栏
    lazy var custNavView:UIView = { [weak self] in
        let view = UIView()
        self?.slideButton.removeFromSuperview()
        self?.slideNavButton.addTarget(self, action: "toggleMenu", forControlEvents: .TouchUpInside)
        view.addSubview(self?.slideNavButton ?? UIView())
        return view
    }()
    
    /// 标题
    var navTitleLabel = UILabel(color: .whiteColor(), title: "热门内容", fontSize: 18, mutiLines: true, fontName: Font.ios8Font)
    /// 搜索顶部
    var headerView = UIView(frame: CGRectMake(0, 0, Frame.screen.width, RecommendContant.headerViewHeight))
    /// 搜索顶部图片
    var headerImageView: RoundImageView = RoundImageView(frame: CGRectMake(0, 0, Frame.screen.width, RecommendContant.headerViewHeight))
    /// 左边侧滑按钮
    lazy var leftRoundButton: SwitchRoundButton = SwitchRoundButton(image: "left_round", title: "", fontSize: 0)
    /// 右边侧滑按钮
    lazy var rightRoundButton: SwitchRoundButton = SwitchRoundButton(image: "right_round", title: "", fontSize: 0)
    /// 标题了解景点背后的故事（无该字体，目前用图片代替） 0.1616:1
    lazy var titleImageView = UIImageView(image: UIImage(named: "launch_title"))
    /// 图片轮播定时器
    var timer: NSTimer?
    /// 内容偏移
    var contentOffSet: CGPoint = CGPointMake(0, -RecommendContant.headerViewHeight)
    /// 是否要刷新标题
    var isRefreshNavBar:Bool = true
    
    
    /// 热门景点和热门内容view
    lazy var titleSelectView: RecommendHotView = { [weak self] in
        let v = RecommendHotView()
        v.hotContentButton.addTarget(self, action: "hotContentAndSightButtonAction:", forControlEvents: .TouchUpInside)
        v.hotSightButton.addTarget(self, action: "hotContentAndSightButtonAction:", forControlEvents: .TouchUpInside)
        return v
    }()
    
    /// 无网络提示view
    lazy var errorView: UIView = { [weak self] in
        let view = UIView()
        let refreshButton = UIButton(icon: "icon_refresh", masksToBounds: true)
        let refreshHint1   = UILabel(color: SceneColor.white.colorWithAlphaComponent(0.5), title: "网速好像不给力", fontSize: 13)
        let refreshHint2   = UILabel(color: SceneColor.white.colorWithAlphaComponent(0.5), title: "点击此处重新加载", fontSize: 13)
        view.frame = CGRectMake(0, RecommendContant.headerViewHeight, UIScreen.mainScreen().bounds.width, 123)
        view.addSubview(refreshButton)
        view.addSubview(refreshHint1)
        view.addSubview(refreshHint2)
        refreshButton.ff_AlignInner(.TopCenter, referView: view, size: CGSize(width: 26, height: 26), offset: CGPointMake(0, 30))
        refreshHint1.ff_AlignVertical(.BottomCenter, referView: refreshButton, size: nil, offset: CGPointMake(0, 12))
        refreshHint2.ff_AlignVertical(.BottomCenter, referView: refreshHint1, size: nil, offset: CGPointMake(0, 0))
        
        //add target
        refreshButton.addTarget(self, action: "refreshFromErrorView:", forControlEvents: UIControlEvents.TouchUpInside)
        self?.view.addSubview(view)
        self?.view.sendSubviewToBack(view)
        view.hidden = true
        return view
        }()
    
    /// 搜索控制器
    lazy var searchController: SearchViewController = SearchViewController()
    /// 热门内容推荐
    var hotContentVC = RecommendHotController()
    /// 热门景点推荐
    var hotSightVC  = RecommendHotController()
    /// 一键向上按钮
    lazy var backUpImageView = UIImageView(image: UIImage(named: "icon_backUp"))
    lazy var backUpControl = UIControl()
    //MARK: - 请求及数据源
    /// 网络请求加载数据(添加)
    var lastRequest: RecommendRequest = RecommendRequest()
    /// 数据源 - 推荐标签
    var recommendLabels: [RecommendLabel] = [RecommendLabel]() {
        didSet{
            if recommendLabels.count == 0 { return }
            titleSelectView.hidden = false
            titleSelectView.hotContentButton.setTitle(recommendLabels[0].name, forState: .Normal)
            titleSelectView.hotSightButton.setTitle(recommendLabels[1].name, forState: .Normal)
            hotContentVC.order   = recommendLabels[0].order ?? "0"
            hotSightVC.order     = recommendLabels[1].order ?? "1"
        }
    }
    
    /// 搜索顶部图片数据源
    var headerImagesData = [String]() {
        didSet {
            headerImageView.arrayImage = headerImagesData
        }
    }
    
    // MARK: - 初始化
    //电池栏状态
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshReachable()
        initCollectionLayout()
        initCollectionView()
        initViewSetting()
        initRoundButton()
        setupAutoLayout()
        loadData()
        initController()
        initSearchBar()
        initBackUpButton()
    }
    
    private func initController() {
        addChildViewController(hotContentVC)
        addChildViewController(hotSightVC)
        hotContentVC.tableView.tag = 2
        hotSightVC.tableView.tag = 2
        hotContentVC.tableView.frame = Frame.screen
        hotSightVC.tableView.frame   = Frame.screen
    }
    
    /// 初始化 collectionview
    private func initCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.bounces    = false
        collectionView.backgroundColor = .clearColor()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }
    
    // 初始化collection布局
    private func initCollectionLayout() {
        layout.itemSize = Frame.screen.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing      = 0
        layout.scrollDirection         = .Horizontal
        collectionView.pagingEnabled   = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func refreshReachable() {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            NSLog("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reachabilityChanged:",
            name: ReachabilityChangedNotification,
            object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            NSLog("Unable to start Reachability Notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            UserProfiler.instance.isViaWiFi = reachability.isReachableViaWiFi() ? true : false
        }
    }
    
    
    /// 初始化searchBar
    func initSearchBar() {
        
        addChildViewController(searchController)
        view.addSubview(searchController.view)
        searchController.view.alpha = 0.0
        view.addSubview(searchController.searchBar)
        let cons = searchController.searchBar.ff_AlignInner(.TopCenter, referView: view, size: CGSizeMake(Frame.screen.width * 0.69, 35), offset: CGPointMake(0, RecommendContant.searchBarTopY))
        searchController.searchBar.updateWidthFrame(Frame.screen.width * 0.69 - 9)
        searchBarMaxX = searchController.searchBar.ff_Constraint(cons, attribute: .CenterX)
        searchBarTopY = searchController.searchBar.ff_Constraint(cons, attribute: .Top)
        searchBarW    = searchController.searchBar.ff_Constraint(cons, attribute: .Width)
        searchBarH    = searchController.searchBar.ff_Constraint(cons, attribute: .Height)
    }
    
    /// 初始化设置
    private func initViewSetting() {
        view.backgroundColor = SceneColor.bgBlack
        
        //nav bar
        navTitleLabel.font = UIFont.systemFontOfSize(18)
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(navContainerView)
        navContainerView.addSubview(custNavView)
        navContainerView.addSubview(navTitleLabel)
        navTitleLabel.ff_AlignInner(.CenterCenter, referView: navContainerView, size: nil, offset: CGPointMake(0, 10))
        navTitleLabel.alpha = 0
        slideNavButton.tintColor = SceneColor.lightYellow
        slideNavButton.setImage(UIImage(named: "icon_hamburger")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        slideNavButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        
        //header
        headerView.clipsToBounds = true
        view.addSubview(headerView)
        headerView.addSubview(headerImageView)
        headerView.addSubview(titleSelectView)
        titleSelectView.hidden = true
        
        let maskView = UIView(color: SceneColor.bgBlack, alphaF: 0.45)
        headerView.addSubview(maskView)
        maskView.ff_AlignInner(.TopLeft, referView: headerView, size: CGSizeMake(Frame.screen.width, RecommendContant.headerViewHeight - 45))
        view.bringSubviewToFront(navContainerView)
        
        view.addSubview(slideView)
        slideView.frame = CGRectMake(-1, 0, 10, Frame.screen.height)
        
        headerView.addSubview(titleImageView)
        titleImageView.alpha = 0.9
        titleImageView.ff_AlignInner(.CenterCenter, referView: headerView, size: nil, offset: CGPointMake(0, -(45 * 0.5)))
    }
    
    /// 初始化左右轮播按钮
    private func initRoundButton() {
        headerView.addSubview(leftRoundButton)
        headerView.addSubview(rightRoundButton)
        leftRoundButton.ff_AlignInner(.CenterLeft, referView: headerView, size: CGSizeMake(18, 24), offset: CGPointMake(0, -20))
        rightRoundButton.ff_AlignInner(.CenterRight, referView: headerView, size:  CGSizeMake(18, 24), offset: CGPointMake(0, -20))
        leftRoundButton.imageViewFrame = CGRectMake(9, 0, 9, 14)
        rightRoundButton.imageViewFrame = CGRectMake(0, 0, 9, 14)
        leftRoundButton.tag = 1
        rightRoundButton.tag = 2
        leftRoundButton.addTarget(self, action: "swipeAction:", forControlEvents: .TouchUpInside)
        rightRoundButton.addTarget(self, action: "swipeAction:", forControlEvents: .TouchUpInside)
    }
    
    /**
     初始化一键向上按钮
     */
    private func initBackUpButton() {
       view.addSubview(backUpImageView)
        view.addSubview(backUpControl)
        backUpImageView.ff_AlignInner(.BottomRight, referView: view, size: CGSizeMake(24, 24), offset: CGPointMake(-9, -22))
        backUpControl.ff_AlignInner(.BottomRight, referView: view, size: CGSizeMake(33, 47))
        backUpControl.addTarget(self, action: "backUpAction", forControlEvents: .TouchUpInside)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isRefreshNavBar {
            refreshBar()
        }
        
        leftRoundButton.hidden = headerImagesData.count > 1 ? false : true
        rightRoundButton.hidden = headerImagesData.count > 1 ? false : true
        if headerImagesData.count > 1 {
            timer = NSTimer(timeInterval: 2.5, target: self, selector: "updatePhotoAction", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func refreshBar(){
        //更新导航背景
        navContainerView.backgroundColor = SceneColor.frontBlack.colorWithAlphaComponent(navBarAlpha)
        //更新导航高度
        navBarHeight = (MainViewContant.MaxNavbarHeight - MainViewContant.MinNavbarHeight) * (1-navBarAlpha) + MainViewContant.MinNavbarHeight
        navContainerView.frame = CGRectMake(0, 0, view.bounds.width, MainViewContant.StatusBarHeight + navBarHeight)
        custNavView.frame      = CGRectMake(0, MainViewContant.StatusBarHeight, view.bounds.width, navBarHeight)
        slideNavButton.frame   = CGRectMake(0, 0, 50, navBarHeight)
    }
    
    //布局
    private func setupAutoLayout() {
        //导航布局
        slideButton.ff_AlignInner(.CenterLeft, referView: custNavView, size: CGSize(width: 21, height: 14), offset: CGPointMake(9, 0))        
        let cons = headerView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, RecommendContant.headerViewHeight))
        titleSelectView.ff_AlignInner(.BottomLeft, referView: headerView, size: CGSizeMake(Frame.screen.width, 45))
        headerViewTopConstraint = headerView.ff_Constraint(cons, attribute: .Top)
        //表格
        collectionView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(Frame.screen.width, Frame.screen.height))
        headerImageView.ff_AlignInner(.TopLeft, referView: headerView, size: CGSizeMake(Frame.screen.width, RecommendContant.headerViewHeight + 20))
    }
    
    //MARK: ScrollViewDelegate
    var yOffset: CGFloat = 0.0
    /// 是否应该更新searchBar的frame
    var isUpdataSearchBarFrame: Bool = false
    /// 是否可以滑动菜单
    var isSlideMenu:Bool = true
    
    /**
     滑动到顶部的方法
     */
    func backUpAction() {
        if collectionView.contentOffset.x == 0 {
            hotContentVC.tableView.setContentOffset(CGPointMake(0, -RecommendContant.headerViewHeight), animated: true)
        } else {
            hotSightVC.tableView.setContentOffset(CGPointMake(0, -RecommendContant.headerViewHeight), animated: true)
        }
    }
}
